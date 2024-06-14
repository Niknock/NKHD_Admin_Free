fx_version 'cerulean'
game 'gta5'

author 'Niknock HD'
description 'NKHD Admin Free Version'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    '@ox_lib/init.lua',
    'client/main.lua',
    'locales/*.lua',
}

server_scripts {
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
    'locales/*.lua',
}

dependencies {
    'es_extended',
    'ox_lib',
    '/assetpacks'
}

lua54 'yes'