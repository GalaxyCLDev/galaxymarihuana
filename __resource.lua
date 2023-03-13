resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'


shared_script '@es_extended/imports.lua'

client_scripts {
	'config.lua',
  'utils.lua',
	'client.lua',
}

server_scripts {	
  '@mysql-async/lib/MySQL.lua',
	'config.lua',
  'utils.lua',
	'server.lua',
}

dependencies {
  'progressBars',
}