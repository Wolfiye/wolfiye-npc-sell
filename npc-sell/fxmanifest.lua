fx_version 'cerulean'
game 'gta5'

author 'Wolfiye'
description 'NPC Sell Script with Quantity Selection, Animation & Item Images'
version '1.2.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@qb-core/shared/locale.lua',
    'server.lua'
}

files {
    'images/*.png'
}

dependencies {
    'ox_lib',
    'ox_target',
    'qb-core'
}
