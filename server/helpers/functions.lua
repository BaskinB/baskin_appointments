VORPcore = exports.vorp_core:GetCore() -- NEW includes  new callback system
BccUtils = exports['bcc-utils'].initiate() -- Initalize BccUtils
-- Version Checker
local repo = 'https://github.com/BaskinB/baskin_appointments'
BccUtils.Versioner.checkRelease(GetCurrentResourceName(), repo)