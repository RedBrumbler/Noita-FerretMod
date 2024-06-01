dofile_once( "data/scripts/lib/utilities.lua" )

--- @brief Get whether ferrets are friends
--- @return boolean
function GetFerretsFriendly()
    return ModSettingGet("ferret_mod.ferret_friends") == true
end

--- @brief get whether to naturally spawn ferrets in biomes at all
--- @return boolean
function GetDoSpawnFerrets()
    return ModSettingGet("ferret_mod.spawn_ferrets") == true
end

--- @brief get whether to spawn some friendly ferrets in the shop
--- @return boolean
function GetDoSpawnFerretsInShop()
    return ModSettingGet("ferret_mod.spawn_ferrets_in_shop") == true
end

--- @brief get whether to add the ferret events to the twitch integration
--- @return boolean
function GetDoAddFerretIntegration()
    return ModSettingGet("ferret_mod.ferret_integration") == true
end

--- @brief Get whether the specific ferret is enabled in the settings
--- @param ferret string the ferret to check for
--- @return boolean enabled whether the ferret is enabled in settings, returns false if it's a ferret the mod doesn't know about
function IsFerretEnabled(ferret)
    local ferretPath = "ferret_mod." .. ferret .. "_enabled"
    local is_enabled = ModSettingGet(ferretPath)
    -- if we can't get the option for this ferret that means it wasn't a valid ferret or the setting for it doesn't exist
    if (is_enabled == nil) then
        print("Could not get config path '" .. ferretPath .. "'")
        return false
    end

    return is_enabled == true
end

--- @brief Get the ferrets the mod knows about
--- @return string[] ferrets the ferrets the mod knows about and has info for
function GetKnownFerrets()
    return {
        [1] = "ghost",
        [2] = "beans",
        [3] = "henry",
        [4] = "loki",
    }
end

--- @brief Get the ferrets the user has enabled in the settings
--- @return string[] enabled_ferrets the ferrets marked as enabled
function GetEnabledFerrets()
    local known_ferrets = GetKnownFerrets()
    local enabled_ferrets = {}

    for _, ferret in pairs(known_ferrets) do
        if IsFerretEnabled(ferret) == true then
            table.insert(enabled_ferrets, ferret)
        end
    end

    return enabled_ferrets
end
