-- file appended to "data/scripts/biomes/temple_altar.lua"
dofile_once( "mods/ferret_mod/files/config_utils.lua" )
dofile_once( "mods/ferret_mod/files/scripts/ferret_utils.lua" )

-- original implementation reference before we override it
orig_init = orig_init or init

function is_inside_wall(x, y, radius)
    for i=1,8 do
        local slice = math.pi * 2 / 8 * i
        local did_hit, hit_x, hit_y = RaytraceSurfacesAndLiquiform(x, y, x + math.cos(slice) * radius, y + math.sin(slice) * radius)
        if did_hit then
            return true
        end
    end
    return false
end

--- @brief override for altar initialization
function init( x, y, w, h )
    -- call orig
    orig_init(x, y, w, h)

    local enabled_ferrets = GetEnabledFerrets()
    if #enabled_ferrets > 0 then
        -- spawn 2 ferrets at the altar location
        local center_x, center_y = x + (w * 0.5), y + (h * 0.5)
        local spawn_x, spawn_y = center_x + 100, center_y + 80

        print("Generated spawn pos: " .. tostring(spawn_x) .. ", " .. tostring(spawn_y))
        if is_inside_wall(spawn_x, spawn_y, 10) then
            print("Generated spawn position was inside a wall, not spawning!")
            return
        end

        for _ = 0, 10 do
            local ferret_id = EntityLoad("mods/ferret_mod/files/ferret.xml", spawn_x, spawn_y)
            -- this will be a friendly ferret, no gold for you!
            SetFerretFriendly(ferret_id, true)
            SetFerretDropsGold(ferret_id, false)
        end
    end
end

orig_spawn_hp = orig_spawn_hp or spawn_hp
function spawn_hp(x, y)
    orig_spawn_hp(x, y)
    print("hp position: " .. tostring(x) .. ", " .. tostring(y))
end
