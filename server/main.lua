RegisterServerEvent('baskin_appointments:InsertCreatedAppointmentIntoDB')
AddEventHandler('baskin_appointments:InsertCreatedAppointmentIntoDB', function(appointmentData)
    local timestamp = os.date("%m/%d/" .. Config.Year)
    local query = "INSERT INTO appointments (id, job, charname, reason, telegram, created_at) VALUES (?, ?, ?, ?, ?, ?)"

    MySQL.insert(query, {
        appointmentData.id,
        appointmentData.job,
        appointmentData.charname,
        appointmentData.reason,
        appointmentData.telegram,
        timestamp
    }, function(rowsChanged)
        if rowsChanged and rowsChanged > 0 then
            print("\027[1m\027[32m[Success] \027[0mAppointment inserted successfully!")
            for _, business in ipairs(Config.Businesses) do
                -- find webhook by job match
                local jobs = (business.jobs and type(business.jobs) == 'table') and business.jobs
                              or ((business.job and type(business.job) == 'string') and { business.job } or {})
                for _, j in ipairs(jobs) do
                    if j == appointmentData.job then
                        local message = "New appointment created for: " .. (appointmentData.charname or "Unknown") ..
                                        " For the reason: " .. (appointmentData.reason or "N/A")
                        BccUtils.Discord.sendMessage(business.webhook, 'Appointment System',
                            'https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png',
                            'New Appointment', message)
                        goto done_webhook
                    end
                end
            end
            ::done_webhook::
        else
            print("\027[1m\027[31m[Error] \027[0mFailed to insert appointment.")
        end
    end)
end)

local function normalizeJobs(business)
    if business.jobs and type(business.jobs) == 'table' then return business.jobs end
    if business.job and type(business.job) == 'string' then return { business.job } end
    return {}
end

local function findBusinessByName(name)
    for _, b in ipairs(Config.Businesses) do
        if b.name == name then return b end
    end
    return nil
end

local function buildPlaceholders(n)
    local t = {}
    for i = 1, n do t[i] = "?" end
    return table.concat(t, ",")
end

RegisterServerEvent('baskin_appointments:GetAllAppointmentsForBusiness')
AddEventHandler('baskin_appointments:GetAllAppointmentsForBusiness', function(businessName)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local playerJob = Character.job

    local business = findBusinessByName(businessName)
    if not business then
        VORPcore.NotifyObjective(src, _U("noAppointmentText"), 4000)
        print('\027[1m\027[31m[Error] \027[0mBusiness not found: ' .. tostring(businessName))
        return
    end

    local jobs = normalizeJobs(business)
    local allowed = false
    for _, j in ipairs(jobs) do if j == playerJob then allowed = true break end end
    if not allowed or #jobs == 0 then
        VORPcore.NotifyObjective(src, _U("noAppointmentText"), 4000)
        print('\027[1m\027[31m[Error] \027[0mPlayer not authorized or no jobs for business: ' .. tostring(businessName))
        return
    end

    local sql = ("SELECT id, charname, telegram, reason, created_at FROM appointments WHERE job IN (%s)"):format(buildPlaceholders(#jobs))
    MySQL.query(sql, jobs, function(appointments)
        if appointments and #appointments > 0 then
            TriggerClientEvent('baskin_appointments:DisplayAllAppointments', src, appointments)
        else
            VORPcore.NotifyObjective(src, _U("noAppointmentText"), 4000)
            print('\027[1m\027[31m[Info] \027[0mNo appointments found for business: ' .. businessName)
        end
    end)
end)

-- legacy: returns all appointments for any business mapped to player's job
RegisterServerEvent('baskin_appointments:GetAllAppointments')
AddEventHandler('baskin_appointments:GetAllAppointments', function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local playerJob = Character.job

    local jobSet = {}
    for _, b in ipairs(Config.Businesses) do
        local jobs = normalizeJobs(b)
        for _, j in ipairs(jobs) do
            if j == playerJob then
                for _, jj in ipairs(jobs) do jobSet[jj] = true end
                break
            end
        end
    end

    local jobList = {}
    for j,_ in pairs(jobSet) do jobList[#jobList+1] = j end
    if #jobList == 0 then
        VORPcore.NotifyObjective(src, _U("noAppointmentText"), 4000)
        print('\027[1m\027[31m[Info] \027[0mPlayer job not mapped to any business.')
        return
    end

    local sql = ("SELECT id, charname, telegram, reason, created_at FROM appointments WHERE job IN (%s)"):format(buildPlaceholders(#jobList))
    MySQL.query(sql, jobList, function(appointments)
        if appointments and #appointments > 0 then
            TriggerClientEvent('baskin_appointments:DisplayAllAppointments', src, appointments)
        else
            VORPcore.NotifyObjective(src, _U("noAppointmentText"), 4000)
            print('\027[1m\027[31m[Info] \027[0mNo appointments found for player access set.')
        end
    end)
end)

RegisterServerEvent('baskin_appointments:DeleteAppointment')
AddEventHandler('baskin_appointments:DeleteAppointment', function(appointmentId)
    local query = "DELETE FROM appointments WHERE id = ?"
    MySQL.query(query, { appointmentId }, function(affectedRows)
        if affectedRows then
            print("\027[1m\027[32m[Success] \027[0mAppointment deleted successfully!")
        else
            print("\027[1m\027[31m[Error] \027[0mFailed to delete appointment.")
        end
    end)
end)