dofile_once( "data/scripts/lib/utilities.lua" )

E_INVALID_FERRET = -1
E_FRIENDLY_FERRET = 1
E_HOSTILE_FERRET = 2
E_SOLDIER_FERRET = 3

local ferret_genomes = {
    [E_FRIENDLY_FERRET] = "friendly_ferret",
    [E_HOSTILE_FERRET] = "hostile_ferret",
    [E_SOLDIER_FERRET] = "soldier_ferret",
}

local genomes_to_ferret = {
    ["friendly_ferret"] = E_FRIENDLY_FERRET,
    ["hostile_ferret"] = E_HOSTILE_FERRET,
    ["soldier_ferret"] = E_SOLDIER_FERRET,
}

local gold_drops = {
    [E_FRIENDLY_FERRET] = false,
    [E_HOSTILE_FERRET] = true,
    [E_SOLDIER_FERRET] = false,
}

local behaviour_tag = "behaviour"

--- @param genome string case sensitive genome string
--- @return integer|nil E_behaviour
function GenomeStringToValue(genome)
    return genomes_to_ferret[genome]
end

--- @param genome integer e_ferret_type
--- @return boolean|nil drops_gold
function GetGenomeDropsGold(genome)
    return gold_drops[genome]
end

--- @brief get the behaviour storage component
--- @param entity_id integer the entity to get/add for
--- @return integer|nil component
function GetBehaviourStorageComponent(entity_id)
    local storage_components = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent") or {}
    for _, c in pairs(storage_components) do
        local n = ComponentGetValue2(c, "name")
        if (n == "behaviour") then
            return c
        end
    end

    return nil
end

--- @param entity_id integer
--- @param genome integer
function SetStoredGenome(entity_id, genome)
    local behaviour_component = GetBehaviourStorageComponent(entity_id)
    if (behaviour_component == nil) then
        print("Can't set stored genome because storage component wasn't found")
        return
    end

    ComponentSetValue2(behaviour_component, "value_int", genome)
end

--- @param entity_id integer
--- @return integer genome
function GetStoredGenome(entity_id)
    local behaviour_component = GetBehaviourStorageComponent(entity_id)
    if (behaviour_component == nil) then
        return E_INVALID_FERRET
    end

    local behaviour_value = ComponentGetValue2(behaviour_component, "value_int")
    if (behaviour_value == nil or behaviour_value == 0) then
        return E_INVALID_FERRET
    end

    return behaviour_value
end

--- @param entity_id integer
--- @param genome integer e_ferret_type
function SetFerretGenome(entity_id, genome)
    -- get genome data component
    local genome_data = EntityGetFirstComponentIncludingDisabled(entity_id, "GenomeDataComponent")
    if genome_data == nil then
        print("Could not set genome to friendly because genome component was not found")
        return
    end

    local genome_name = ferret_genomes[genome]
    if genome_name == nil then
        print("Invalid genome number was passed to SetFerretGenome, can't set this!")
        return
    end


    local genome_id = StringToHerdId(genome_name)
    -- print("Setting genome " .. genome_name .. " (id " .. tostring(genome_id) .. ")")
    component_write(genome_data, { herd_id = genome_id })
    SetStoredGenome(entity_id, genome)

    -- if ferret is friendly and friendlies are invuln, set damage model enabled state to true
    local friendly_and_invuln = (genome == E_FRIENDLY_FERRET) and GetFriendlyFerretsInvulnerable()
    SetDamageModelActive(entity_id, not friendly_and_invuln)
end

--- @param entity_id integer
--- @param friendly boolean
function SetFerretFriendly(entity_id, friendly)
    local bool_to_E_ferret = {
        [true] = E_FRIENDLY_FERRET,
        [false] = E_HOSTILE_FERRET
    }

    SetFerretGenome(entity_id, bool_to_E_ferret[friendly == true])
end

--- @brief add or remove a variablestorage component with the "no_gold_drop" tag to enable/disable gold drops
--- @param entity_id integer id of the ferret
--- @param drop_gold boolean whether to drop gold or not
function SetFerretDropsGold(entity_id, drop_gold)
    local no_gold_drop_component = EntityGetFirstComponentIncludingDisabled(entity_id, "VariableStorageComponent", "no_gold_drop")

    if drop_gold and no_gold_drop_component ~= nil then
        -- we want gold to drop, but a no gold drop component is on here, remove it!
        EntityRemoveComponent(entity_id, no_gold_drop_component)
    elseif not drop_gold and no_gold_drop_component == nil then
        -- we don't want gold to drop, but we don't have a no gold component, add it!
        local component = EntityAddComponent2(entity_id, "VariableStorageComponent")
        ComponentAddTag(component, "no_gold_drop")
    end
end

--- @param entity_id integer
function GetHasAnyFerretSkin(entity_id)
    local sprite_component = EntityGetFirstComponent(entity_id, "SpriteComponent")

    -- we don't null check sprite component here because component_read already does that
    -- read the image file for the sprite, and check whether it contains our ferret_gfx path
    local was_set = false
    component_read(sprite_component, {
        image_file = ""
    }, function(comp)
            local s, _ = string.find(comp.image_file, "ferret_gfx", 0, true)
            was_set = s ~= nil and s > 0
        end
    )

    return was_set
end

--- @param entity_id integer
--- @param ferret string
function SetFerretSkin(entity_id, ferret)
    if entity_id == nil or ferret == nil then
        print("Entity id or ferret was nil, not setting skin!")
        print("Entity id : " .. tostring(entity_id))
        print("Ferret    : " .. tostring(ferret))
        return
    end

    local sprite_component = EntityGetFirstComponent(entity_id, "SpriteComponent")
    local damage_component = EntityGetFirstComponent(entity_id, "DamageModelComponent")

    -- if we can't get the components just return
    if sprite_component == nil or damage_component == nil then return end

    -- set the xml for the right sprite sheet
    component_write(sprite_component, {
        image_file = "mods/ferret_mod/files/ferret_gfx/" .. ferret .. ".xml",
        offset_x = 10,
        offset_y = 10
    })

    -- set the ragdoll filenames file
    component_write(damage_component, {ragdoll_filenames_file = "mods/ferret_mod/files/ferret_ragdolls/" .. ferret .. "/filenames.txt"})
end

--- @brief sets the damage model active or not
--- @param entity_id integer
--- @param active boolean
function SetDamageModelActive(entity_id, active)
    local damage_model = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
    if damage_model == nil then
        print("Can't set damage model active state because it wasn't found on entity")
        return
    end

    print("Setting damage model enabled: " .. tostring(entity_id) .. ", " .. tostring(damage_model) .. ", " .. tostring(active))

    EntitySetComponentIsEnabled(entity_id, damage_model, active)
end
