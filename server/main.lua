---------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------- Server File (This is code that is run globally on the server) ----------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------


---------------- VORP Core Export API Examples ----------------
-- local Character = VorpCore.getUser(_source).getUsedCharacter

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
            print("Appointment inserted successfully!")
        else
            print("Failed to insert appointment.")
        end
    end)
end)

RegisterServerEvent('tgrp_appointments:GetAllAppointments', function(job)
    local timestamp = os.date("%m/%d/" .. Config.Year)
    local _source = source
    local Character = VORPcore.getUser(source).getUsedCharacter
    local job = Character.job
    -- Fetch all entries from the appointments table for the specified job
    local query = "SELECT * FROM appointments WHERE job = @job"
    MySQL.Async.fetchAll(query, {['@job'] = job, {['@created_at'] = timestamp}}, function(appointments)
        if #appointments > 0 then
            -- Sending appointments for the specified job to the client
            TriggerClientEvent('tgrp_appointments:DisplayAllAppointments', _source, appointments)
        else
            print("No appointments found for the specified job.")
        end
    end)
end)