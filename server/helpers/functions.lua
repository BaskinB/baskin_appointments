-- -----------------------------------------------------
-- 		____            _    _       _
-- 		|  _ \          | |  (_)     | |
-- 		| |_) | __ _ ___| | ___ _ __ | |__
-- 		|  _ < / _` / __| |/ / | '_ \| '_ \
-- 		| |_) | (_| \__ \   <| | | | | |_) |
-- 		|____/ \__,_|___/_|\_\_|_| |_|_.__/
--
-- 		Written and Developed by Baskin
-- -----------------------------------------------------

VORPcore = exports.vorp_core:GetCore()     -- NEW includes  new callback system
BccUtils = exports['bcc-utils'].initiate() -- Initalize BccUtils
-- Version Checker
local repo = 'https://github.com/BaskinB/baskin_appointments'
BccUtils.Versioner.checkRelease(GetCurrentResourceName(), repo)

-- Credits to Jake2k4 for this snippet.
CreateThread(function()
  if GetCurrentResourceName() ~= "baskin_appointments" then
    error("Resource must be named baskin_appointments, failed to launch script.")
  end
end)
