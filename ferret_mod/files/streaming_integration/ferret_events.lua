dofile_once( "mods/ferret_mod/files/scripts/ferret_utils.lua" )
-- this file adds some events to the streaming integration that lets chat spawn ferrets

FERRETMOD_UI_AUTHOR = "RedBrumbler - FerretMod"

-- spawns a kind of ferret on the player
function spawn_ferrets_on_player(count, genome)
    -- for every player
    for i, entity_id in pairs(get_players()) do
        local x, y = EntityGetTransform(entity_id)
        for i in 0, count do
            local ferret_id = EntityLoad("mods/ferret_mod/files/ferret.xml", x, y)
            -- update behaviour based on genome
            SetFerretGenome(ferret_id, genome)
            -- summoned ferrets don't ever drop gold
            SetFerretDropsGold(ferret_id, false)
        end
    end
end

function spawn_specific_ferret_on_player(ferret, genome)
    for _, entity_id in pairs(get_players()) do
        local x, y = EntityGetTransform(entity_id)
        local ferret_id = EntityLoad("mods/ferret_mod/files/ferrets/" .. ferret .. ".xml", x, y)
        if ferret_id ~= nil then
            -- update behaviour based on genome
            SetFerretGenome(ferret_id, genome)
            -- summoned ferrets don't ever drop gold
            SetFerretDropsGold(ferret_id, false)
        end
    end
end

-- ferret party is an event where it just spawns a bunch of friendly ferrets
table.insert(streaming_events, {
    id = "FERRETMOD_FERRET_PARTY",
    ui_name = "$integration_ferretmod_FERRET_PARTY_name",
    ui_description = "$integration_ferretmod_FERRET_PARTY_desc",
    ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
    -- ui_icon = "mods/ferret_mod/streaming_integration/ferret_party.png",
    ui_author = FERRETMOD_UI_AUTHOR,
    weight = 1.0,
    kind = STREAMING_EVENT_NEUTRAL,
    action = function()
        spawn_ferrets_on_player(5, E_FRIENDLY_FERRET)
    end
})

-- ferret party is an event where it spawns a bunch of ferrets that will attack everything except the player
table.insert(streaming_events, {
    id = "FERRETMOD_FERRET_ARMY",
    ui_name = "$integration_ferretmod_FERRET_ARMY_name",
    ui_description = "$integration_ferretmod_FERRET_ARMY_desc",
    ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
    -- ui_icon = "mods/ferret_mod/streaming_integration/ferret_army.png",
    ui_author = FERRETMOD_UI_AUTHOR,
    weight = 1.0,
    kind = STREAMING_EVENT_GOOD,
    action = function()
        spawn_ferrets_on_player(5, E_SOLDIER_FERRET)
    end
})

-- ferret attack is an event where it spawns a bunch of ferrets that will only attack the player
table.insert(streaming_events, {
    id = "FERRETMOD_FERRET_ATTACK",
    ui_name = "$integration_ferretmod_FERRET_ATTACK_name",
    ui_description = "$integration_ferretmod_FERRET_ATTACK_desc",
    ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
    -- ui_icon = "mods/ferret_mod/streaming_integration/ferret_attack.png",
    ui_author = FERRETMOD_UI_AUTHOR,
    weight = 0.75,
    kind = STREAMING_EVENT_BAD,
    delay_timer = 300,
    action_delayed = function()
        spawn_ferrets_on_player(5, E_HOSTILE_FERRET)
    end
})

-- spawn a single henry
table.insert(streaming_events, {
    id = "FERRETMOD_HENRY",
    ui_name = "$integration_ferretmod_HENRY_name",
    ui_description = "$integration_ferretmod_HENRY_desc",
    ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
    -- ui_icon = "mods/ferret_mod/streaming_integration/ferret_attack.png",
    ui_author = FERRETMOD_UI_AUTHOR,
    weight = 0.3,
    kind = STREAMING_EVENT_NEUTRAL,
	delay_timer = 300,
    action_delayed = function()
        spawn_specific_ferret_on_player("henry", E_FRIENDLY_FERRET)
    end
})

-- spawn a single beans
table.insert(streaming_events, {
    id = "FERRETMOD_BEANS",
    ui_name = "$integration_ferretmod_BEANS_name",
    ui_description = "$integration_ferretmod_BEANS_desc",
    ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
    -- ui_icon = "mods/ferret_mod/streaming_integration/ferret_attack.png",
    ui_author = FERRETMOD_UI_AUTHOR,
    weight = 0.3,
    kind = STREAMING_EVENT_NEUTRAL,
	delay_timer = 300,
    action_delayed = function()
        spawn_specific_ferret_on_player("beans", E_FRIENDLY_FERRET)
    end
})

-- spawn a single ghost
table.insert(streaming_events, {
    id = "FERRETMOD_GHOST",
    ui_name = "$integration_ferretmod_GHOST_name",
    ui_description = "$integration_ferretmod_GHOST_desc",
    ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
    -- ui_icon = "mods/ferret_mod/streaming_integration/ferret_attack.png",
    ui_author = FERRETMOD_UI_AUTHOR,
    weight = 0.3,
    kind = STREAMING_EVENT_NEUTRAL,
	delay_timer = 300,
    action_delayed = function()
        spawn_specific_ferret_on_player("ghost", E_FRIENDLY_FERRET)
    end
})

-- spawn a single beans
table.insert(streaming_events, {
    id = "FERRETMOD_LOKI",
    ui_name = "$integration_ferretmod_LOKI_name",
    ui_description = "$integration_ferretmod_LOKI_desc",
    ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
    -- ui_icon = "mods/ferret_mod/streaming_integration/ferret_attack.png",
    ui_author = FERRETMOD_UI_AUTHOR,
    weight = 0.3,
    kind = STREAMING_EVENT_NEUTRAL,
	delay_timer = 300,
    action_delayed = function()
        spawn_specific_ferret_on_player("loki", E_FRIENDLY_FERRET)
    end
})
