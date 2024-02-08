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

RegisterServerEvent('tgrp_appointments:GetAllAppointments', function(appointmentId)
    local _source = source
    local Character = VORPcore.getUser(source).getUsedCharacter
    local job = Character.job
    -- Fetch all entries from the appointments table for the specified job
    local query = "SELECT id, charname, telegram, reason, created_at FROM appointments WHERE job = @job"
    MySQL.Async.fetchAll(query, {['@job'] = job}, function(appointments)
        if appointments and #appointments > 0 then
            TriggerClientEvent('tgrp_appointments:DisplayAllAppointments', _source, appointments)
        else
            print("No appointments found for the specified job.")
        end
    end)
end)

RegisterServerEvent('baskin_appointments:DeleteAppointment')
AddEventHandler('baskin_appointments:DeleteAppointment', function(appointmentId)
    local query = "DELETE FROM appointments WHERE id = ?"
    exports.oxmysql:execute(query, {appointmentId}, function(affectedRows)
        if affectedRows then
            print("Appointment deleted successfully!")
        else
            print("Failed to delete appointment.")
        end
    end)
end)

--[[ RegisterNetEvent('baskin_appointments:DeleteAppointment', function (appointId)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter

    exports.oxmysql:execute('DELETE FROM appointments WHERE id = ?', {appointId}, function (rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent("vorp:TipRight", _source, "Appointment deleted.", 5000)
        else
            TriggerClientEvent("vorp:TipRight", _source, "Failed to delete Appointment.", 5000)
        end
    end)
end) ]]