fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'
lua54 'yes'

author 'Spooni'
description 'Guarma Travel Script'
version '2'

shared_scripts {
    'shared/*.lua',
}

server_scripts {
    'server/sv_functions.lua',
    'server/sv_main.lua',
    'server/sv_version.lua',
}

client_scripts {
    'client/cl_prompts.lua',
    'client/cl_blips.lua',
    'client/cl_npc.lua',
    'client/cl_functions.lua',
    'client/cl_main.lua',
}