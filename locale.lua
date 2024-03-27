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


Locales = {} --Creadit to bcc-boats for this

function _(str, ...) -- Translate string

	if Locales[Config.defaultLang] ~= nil then

		if Locales[Config.defaultLang][str] ~= nil then
			return string.format(Locales[Config.defaultLang][str], ...)
		else
			return 'Translation [' .. Config.defaultLang .. '][' .. str .. '] does not exist'
		end

	else
		return 'Locale [' .. Config.defaultLang .. '] does not exist'
	end

end

function _U(str, ...) -- Translate string first char uppercase
	return tostring(_(str, ...):gsub("^%l", string.upper))
end