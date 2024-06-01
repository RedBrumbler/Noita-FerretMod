dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "mods/ferret_mod/files/config_utils.lua" )
dofile_once( "mods/ferret_mod/files/scripts/ferret_utils.lua" )

local default_skin = "beans"

--- @param entity_id integer entity id
function init(entity_id)
    print("ferret.init", entity_id)
    local enabled_ferrets = GetEnabledFerrets()

    -- check whether this spawned entity has a ferret model set already
    if GetHasAnyFerretSkin(entity_id) == false then
        local ferret_skin = default_skin
        if #enabled_ferrets > 0 then
            -- seed random
            SetRandomSeed(entity_id, GameGetFrameNum())
            ferret_skin = random_from_array(enabled_ferrets)
        end

        SetFerretSkin(entity_id, ferret_skin)
        -- name this ferret the same as its skin
        EntitySetName(entity_id, ferret_skin)
    end

    local genome = GetStoredGenome(entity_id)
    print("genome before setup: " .. tostring(genome))
    -- if it wasn't already set or invalid, set it up so it works
    if genome == E_INVALID_FERRET then
        print("fresh")
        local friendly = GetFerretsFriendly()
        SetFerretFriendly(entity_id, friendly)

        -- friendly ferrets should not drop gold, make it unappealing to shoot them
        SetFerretDropsGold(entity_id, friendly == false)
    else
        print("recycle")
        SetFerretGenome(entity_id, genome)
        SetFerretDropsGold(entity_id, GetGenomeDropsGold(genome) == true)
    end

    genome = GetStoredGenome(entity_id)
    print("genome after setup: " .. tostring(genome))
end
