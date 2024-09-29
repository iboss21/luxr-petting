-- fxmanifest.lua

fx_version 'cerulean'
game 'rdr3'

author "iBoss. The Land of Wolve"
description "Petting Interaction Script for RSG-Core in RedM"
version "1.0.0"

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

lua54 'yes'

-- Specify dependencies
dependencies {
    'rsg-core',
    --'BGS_Cats' -- Credit to original creator
}

-- Shared configurations
shared_scripts {
    'config.lua'
}

-- Client-side scripts
client_scripts {
    'client/client.lua',
}

-- Server-side scripts
server_scripts {
    'server/server.lua',
}
