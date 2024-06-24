-- init.lua is ran when the player enters gameplay, no matter if it's a new game or continue from old game

dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "mods/ferret_mod/files/ferret_genomes.lua" )
dofile_once( "mods/ferret_mod/files/config_utils.lua" )

-- add ferret spawns as an option to coalmine and excavationsite (area 1 and 2)
if GetDoSpawnFerrets() then
    ModLuaFileAppend( "data/scripts/biomes/coalmine.lua", "mods/ferret_mod/files/biomes/ferret_biome_appends.lua")
    ModLuaFileAppend( "data/scripts/biomes/excavationsite.lua", "mods/ferret_mod/files/biomes/ferret_biome_appends.lua")
end

-- add friendly ferrets to the shop area
if GetDoSpawnFerretsInShop() then
    ModLuaFileAppend( "data/scripts/biomes/temple_altar_left.lua", "mods/ferret_mod/files/biomes/ferret_altar_appends.lua")
end

-- append to the streaming integration event list to add some events that spawn a bunch of ferrets
if GetDoAddFerretIntegration() then
    ModLuaFileAppend( "data/scripts/streaming_integration/event_list.lua", "mods/ferret_mod/files/streaming_integration/ferret_events.lua")
end

-- add ferret spells
ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/ferret_mod/files/actions/gun_actions.lua")

-- add translations
-- ,en,ru,pt-br,es-es,de,fr-fr,it,pl,zh-cn,jp,ko,,NOTES – use \n for newline,max length,,,,,,,,,,
local content = ModTextFileGetContent("data/translations/common.csv")
ModTextFileSetContent("data/translations/common.csv", (content .. [[
ferretmod_animal_ferret,ferret,хорёк,,hurón,frettchen,furet,furetto,fretka,,,,,,
integration_ferretmod_FERRET_PARTY_name,Ferret Party,,,,,,,,,,,,,
integration_ferretmod_FERRET_PARTY_desc,Spawn some friendly ferrets,,,,,,,,,,,,,
integration_ferretmod_FERRET_ARMY_name,Ferret Army,,,,,,,,,,,,,
integration_ferretmod_FERRET_ARMY_desc,Spawn some ferret soldiers,,,,,,,,,,,,,
integration_ferretmod_FERRET_ATTACK_name,Ferret Attack,,,,,,,,,,,,,
integration_ferretmod_FERRET_ATTACK_desc,Spawn some hostile ferrets,,,,,,,,,,,,,
integration_ferretmod_HENRY_name,Henry the ferret,,,,,,,,,,,,,
integration_ferretmod_HENRY_desc,Did someone say swiss cheese?,,,,,,,,,,,,,
integration_ferretmod_BEANS_name,Beans the ferret,,,,,,,,,,,,,
integration_ferretmod_BEANS_desc,,,,,,,,,,,,,,
integration_ferretmod_GHOST_name,Ghost the ferret,,,,,,,,,,,,,
integration_ferretmod_GHOST_desc,,,,,,,,,,,,,,
integration_ferretmod_LOKI_name,Loki the ferret,,,,,,,,,,,,,
integration_ferretmod_LOKI_desc,,,,,,,,,,,,,,
integration_ferretmod_SHAPE_OF_FERRET_name,Shape Of Ferret,,,,,,,,,,,,,
integration_ferretmod_SHAPE_OF_FERRET_desc,Spawns a spell to shape projectiles as ferrets,,,,,,,,,,,,,
ferretmod_action_ferret_shape,Shape Of Ferret,,,,,,,,,,,,,
ferretmod_action_ferret_shape_desc,Adorable ferrets will shape your projectiles. The longer they exist the unrulier they become,,,,,,,,,,,,,
]]):gsub("\r\n","\n"):gsub("\n\n","\n"))
