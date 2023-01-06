fx_version 'cerulean'

author 'Coffeelot and Wuggie'
description 'CW rgb painter'
game 'gta5'

ui_page 'html/index.html'


files {
	'html/*',
    'html/recipeImages/*'
}

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua',
}

client_scripts{
    'client/*.lua',
}

server_scripts{
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

dependency{
    'oxmysql',
}


exports {
    'getOldJobs'
}