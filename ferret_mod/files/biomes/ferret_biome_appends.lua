dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "mods/ferret_mod/files/config_utils.lua")


local ferret_enemy = {
    prob   		= 0.3,
    -- always spawn at least 2 ferrets, because ferrets get lonely if they're on their own
    min_count	= 2,
    max_count	= 2,
    entity 	= "mods/ferret_mod/files/ferret.xml",
    spawn_check = function()
        -- if anything is in the list, that means we have some ferrets enabled, which means spawning a ferret makes sense
        if #GetEnabledFerrets() > 0 then
            return true
        end

        return false
    end
}

table.insert(g_small_enemies, ferret_enemy)
