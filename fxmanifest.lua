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

fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
version '1.0.6'
author 'Baskin'
description 'Appointment System for VORP Core'

client_scripts {
  'client/menu.lua',
  'client/helpers/functions.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/main.lua',
  'server/helpers/functions.lua',
}

shared_scripts {
  'config.lua',
  'locale.lua',
  'languages/*.lua'
}

--------------------------------------------------------------------------------------

---------------- Dependencies -------------------------------------------------------
---- What other scripts (if any) does your script depend on. REMOVE THIS IF NONE ----
dependencies {
  'vorp_core',
  'vorp_character',
  'bcc-utils',
  'feather-menu',
}
