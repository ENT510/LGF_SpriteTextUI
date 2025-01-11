fx_version 'cerulean'
game 'gta5'
version '1.0.0'
lua54 'yes'
author 'ENT510'

shared_scripts {
  '@ox_lib/init.lua',
}

client_scripts {
  'Modules/Client/cl-nui.lua',
  'Modules/Client/cl-exports.lua',
  'Modules/Client/cl-example.lua',
}

files {
  'Modules/Client/cl-config.lua',
  'web/build/index.html',
  'web/build/**/*',
}

ui_page 'web/build/index.html'
