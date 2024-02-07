fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
version '0.0.1'
author 'Baskin'

client_scripts {
   'client/main.lua',
   'client/menu.lua',
   'client/functions.lua'
}

server_scripts {
   '@oxmysql/lib/MySQL.lua',
   'server/main.lua',
}

shared_scripts {
   'config.lua',
   --'shared/locale.lua',
   --'languages/*.lua',
   'shared/functions.lua'
}

--------------------------------------------------------------------------------------

---------------- Dependencies -------------------------------------------------------
---- What other scripts (if any) does your script depend on. REMOVE THIS IF NONE ----
dependencies { 
    'vorp_core'
}
--------------------------------------------------------------------------------------

---------------- Exports -------------------------------------------------------------
------------- If you need ------------------------------------------------------------
exports {}
--------------------------------------------------------------------------------------