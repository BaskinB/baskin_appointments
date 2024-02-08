VORPcore = exports.vorp_core:GetCore() -- NEW includes  new callback system

local repo = 'https://github.com/BaskinB/baskin_appointments'
BccUtils.Versioner.checkRelease(GetCurrentResourceName(), repo)

if GetResourceState("vorp_core") == "missing" then
    print("\027[1m\027[31m[Baskin_Appointment] \027VORP_Core is Missing.")
end

if GetResourceState("vorp_character") == "missing" then
    print("\027[1m\027[31m[Baskin_Appointment] \027VORP_Character is Missing.")
end

if GetResourceState("bcc-utils") == "missing" then
    print("\027[1m\027[31m[Baskin_Appointment] \027BCC-Utils is Missing.")
end

if GetResourceState("feather-menu") == "missing" then
    print("\027[1m\027[31m[Baskin_Appointment] \027Feather Menu is Missing.")
end