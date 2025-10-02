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
local function versionCheck(repository)
  local resource = GetInvokingResource() or GetCurrentResourceName()

  local currentVersion = GetResourceMetadata(resource, 'version', 0)

  if currentVersion then
    currentVersion = currentVersion:match('%d+%.%d+%.%d+')
  end

  if not currentVersion then return print(("^1Unable to determine current resource version for '%s' ^0"):format(resource)) end

  SetTimeout(1000, function()
    PerformHttpRequest(('https://api.github.com/repos/%s/releases/latest'):format(repository), function(status, response)
      if status ~= 200 then return end

      response = json.decode(response)
      if response.prerelease then return end

      local latestVersion = response.tag_name:match('%d+%.%d+%.%d+')
      if not latestVersion or latestVersion == currentVersion then return end

      local cv = { string.strsplit('.', currentVersion) }
      local lv = { string.strsplit('.', latestVersion) }

      for i = 1, #cv do
        local current, minimum = tonumber(cv[i]), tonumber(lv[i])

        if current ~= minimum then
          if current < minimum then
            return print(('^3An update is available for %s (current version: %s)\r\n%s^0'):format(resource,
              currentVersion, response.html_url))
          else
            break
          end
        end
      end
    end, 'GET')
  end)
end

versionCheck('BaskinB/baskin_appointments')

-- Credits to Jake2k4 for this snippet.
CreateThread(function()
  if GetCurrentResourceName() ~= "baskin_appointments" then
    error("Resource must be named baskin_appointments, failed to launch script.")
  end
end)
