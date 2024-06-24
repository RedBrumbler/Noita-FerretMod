dofile_once("data/scripts/lib/utilities.lua")

-- sign function
local function sign(x)
    if x < 0 then
        return -1
    elseif x > 0 then
        return 1
    end

    return 0
end

local entity_id = GetUpdatedEntityID();
-- get velocity component, if not found there's no point in this
local velocity_comp = EntityGetFirstComponent( entity_id, "VelocityComponent")
if velocity_comp == nil then return end
-- get current projectile angle
local pos_x, pos_y, rad = EntityGetTransform( entity_id )
-- current velocities
local vel_x, vel_y = ComponentGetValue2(velocity_comp, "mVelocity")

-- get our t, start at either of the 0 points of a sin function
local t = GetValueNumber("t", Random(0, 1) * math.pi)
-- calculate magnitude
local offset_magnitude = math.sin(t * math.pi * 2) * 20
-- update t
SetValueNumber("t", t + 0.2)

-- calculate a random starting direction (up or down right angle)
local angle_direction = GetValueInteger("angle_direction", (Random(0, 1) * 2) - 1)

-- calculate a right angle (up or down)
local right_angle = angle_direction * 0.5 * math.pi * sign(offset_magnitude)

-- calculate the angle that's a right angle on the current angle of the projectile
local offset_angle = rad + right_angle
-- add velocity based on offset_angle * magnitude
vel_x = vel_x + math.cos(offset_angle) * offset_magnitude
vel_y = vel_y + math.sin(offset_angle) * offset_magnitude

-- set new velocity
ComponentSetValueVector2(velocity_comp, "mVelocity", vel_x, vel_y)
