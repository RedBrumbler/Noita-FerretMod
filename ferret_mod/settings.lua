dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.

-- This file can't access other files from this or other mods in all circumstances.
-- Settings will be automatically saved.
-- Settings don't have access unsafe lua APIs.

-- Use ModSettingGet() in the game to query settings.
-- For some settings (for example those that affect world generation) you might want to retain the current value until a certain point, even
-- if the player has changed the setting while playing.
-- To make it easy to define settings like that, each setting has a "scope" (e.g. MOD_SETTING_SCOPE_NEW_GAME) that will define when the changes
-- will actually become visible via ModSettingGet(). In the case of MOD_SETTING_SCOPE_NEW_GAME the value at the start of the run will be visible
-- until the player starts a new game.
-- ModSettingSetNextValue() will set the buffered value, that will later become visible via ModSettingGet(), unless the setting scope is MOD_SETTING_SCOPE_RUNTIME.

local mod_id = "ferret_mod" -- This should match the name of your mod's folder.
mod_settings_version = 3 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings = {
	{
		id = "ferret_integration",
		ui_name = "Twitch ferret integration",
		ui_description = "Add some ferret events to the twitch integration,\nletting chat spawn ferrets at the player location",
		value_default = true,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "ferret_path",
		ui_name = "Shape of Ferret Affects Projectile Path",
		ui_description = "Whether Shape of Ferret also makes your projectiles do weird ferret jank.\nMostly there to balance out the reduced mana cost which is basically free.",
		value_default = true,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		category_id = "ferret_behaviour",
		foldable = false,
		ui_name = "Ferret behaviour",
		ui_description = "Some options to change what ferrets can do",
		settings = {
			{
				id = "ferret_friends",
				ui_name = "Ferrets are friendly",
				ui_description = "Whether ferrets are friendly to the player\nFriendly or allied ferrets don't drop gold\nTo discourage bad behaviour",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "friendly_invulnerable",
				ui_name = "Friendly Ferrets Invulnerable",
				ui_description = "Friendly ferrets are invulnerable",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "everything_invulnerable",
				ui_name = "All Ferrets Invulnerable",
				ui_description = "Option for Thor who doesn't want to hurt any ferrets\nFerrets will still bite you though!",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			}
		}
	},
	{
		category_id = "ferret_spawns",
		foldable = false,
		ui_name = "Spawn behaviour",
		ui_description = "Where will ferrets spawn?",
		settings = {
			{
				id = "spawn_ferrets",
				ui_name = "Spawn ferrets naturally",
				ui_description = "Whether ferrets spawn naturally in various biomes",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "spawn_ferrets_in_shop",
				ui_name = "Spawn ferrets in shop",
				ui_description = "Spawn some friendly ferrets in the shop area\nUnwise if you decide to anger the gods",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			}
		}
	},
	{
		category_id = "enabled_ferrets",
		foldable = true,
		_folded = true,
		ui_name = "Enabled Ferrets",
		ui_description = "Enable various ferret skins to spawn\nOnly changes the pool for newly spawned ferrets",
		settings = {
			{
				id = "ghost_enabled",
				ui_name = "Ghost (F)",
				ui_description = "Ghost the ferret",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				id = "beans_enabled",
				ui_name = "Beans (M)",
				ui_description = "Beans the ferret",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				id = "henry_enabled",
				ui_name = "Henry (M)",
				ui_description = "Henry the ferret, did someone say swiss cheese?",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				id = "loki_enabled",
				ui_name = "Loki (F)",
				ui_description = "Loki the ferret",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
		},
	},
}

-- This function is called to ensure the correct setting values are visible to the game via ModSettingGet(). your mod's settings don't work if you don't have a function like this defined in settings.lua.
-- This function is called:
--		- when entering the mod settings menu (init_scope will be MOD_SETTINGS_SCOPE_ONLY_SET_DEFAULT)
-- 		- before mod initialization when starting a new game (init_scope will be MOD_SETTING_SCOPE_NEW_GAME)
--		- when entering the game after a restart (init_scope will be MOD_SETTING_SCOPE_RESTART)
--		- at the end of an update when mod settings have been changed via ModSettingsSetNextValue() and the game is unpaused (init_scope will be MOD_SETTINGS_SCOPE_RUNTIME)
function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
	mod_settings_update( mod_id, mod_settings, init_scope )
end

-- This function should return the number of visible setting UI elements.
-- Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
-- If your mod changes the displayed settings dynamically, you might need to implement custom logic.
-- The value will be used to determine whether or not to display various UI elements that link to mod settings.
-- At the moment it is fine to simply return 0 or 1 in a custom implementation, but we don't guarantee that will be the case in the future.
-- This function is called every frame when in the settings menu.
function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
