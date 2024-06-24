dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/ferret_mod/files/config_utils.lua")

-- adds a ferret modifier for projectiles. To make up for the reduce mana cost, the projectiles will get a bit janky the longer they exist
local ferretmod_custom_actions = {
    {
		id          = "FERRETMOD_FERRET_SHAPE",
		name 		= "$ferretmod_action_ferret_shape",
		description = "$ferretmod_action_ferret_shape_desc",
		sprite 		= "mods/ferret_mod/files/ui_gfx/ferret_shape.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,5,6", -- FERRETMOD_FERRET_SHAPE
		spawn_probability                 = "0.2,0.2,0.4,0.4,0.6,0.8,0.8", -- FERRETMOD_FERRET_SHAPE
		price = 100,
		mana = -10,
		action 		= function()
            local ferret = random_from_array(GetKnownFerrets())
			-- check with the config whether to add the janky movement
			if GetDoFerretPath() then
				-- this extra entity adds the janky movement
				c.extra_entities = c.extra_entities .. "mods/ferret_mod/files/ferret_path.xml,"
			end

			-- pick a random bullet shape
            c.sprite = "mods/ferret_mod/files/ferret_gfx/bullet_shape/" .. ferret .. ".xml";

			-- force draw with the sprite
            draw_actions(1, true)
		end,
    }
}

-- add our custom actions
for _, a in pairs(ferretmod_custom_actions) do
    table.insert(actions, a)
end
