RegisterServerEvent('tgrp_appointments:InsertCreatedAppointmentIntoDB', function(appointmentData)
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
        if rowsChanged > 0 then
            print("\027[1m\027[32m[Success] \027[0mAppointment inserted successfully!")
        else
            print("\027[1m\027[31m[Error] \027[0mFailed to insert appointment.")
        end
    end)
end)

RegisterServerEvent('tgrp_appointments:GetAllAppointments', function(appointmentId)
    local _source = source
    local Character = VORPcore.getUser(source).getUsedCharacter
    local job = Character.job
    -- Fetch all entries from the appointments table for the specified job
    local query = "SELECT id, charname, telegram, reason, created_at FROM appointments WHERE job = @job"
    MySQL.query(query, {['@job'] = job}, function(appointments)
        if appointments and #appointments > 0 then
            TriggerClientEvent('tgrp_appointments:DisplayAllAppointments', _source, appointments)
        else
            VORPcore.NotifyObjective(_source,_U("noappointmenttext"),4000)
            print('\027[1m\027[31m[Error] \027[0mNo appointments found for the specified job')
        end
    end)
end)

RegisterServerEvent('baskin_appointments:DeleteAppointment')
AddEventHandler('baskin_appointments:DeleteAppointment', function(appointmentId)
    local query = "DELETE FROM appointments WHERE id = ?"
    MySQL.query(query, {appointmentId}, function(affectedRows)
        if affectedRows then
            print("\027[1m\027[32m[Success] \027[0mAppointment deleted successfully!")
        else
            print("\027[1m\027[31m[Error] \027[0mFailed to delete appointment.")
        end
    end)
end)
