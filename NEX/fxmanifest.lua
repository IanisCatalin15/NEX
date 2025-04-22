-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'Ianis Catalin'
description 'NEX Framework for FiveM'
version '1.0.0'

shared_scripts {
    'NEXShared.lua',
    'shared/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'lib/Proxy.lua',
    'lib/Tunnel.lua',
    'lib/Database.lua',
    'server/*.lua',
    'server/services/*.lua',
    'NEX.lua',
    'Base.lua',
    'User.lua'
}

client_scripts {
    'lib/Proxy.lua',
    'lib/Tunnel.lua',
    'client/*.lua'
}

files {
    'cfg/*.lua',
    'sql/*.sql'
}