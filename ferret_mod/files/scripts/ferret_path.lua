dofile_once("data/scripts/lib/utilities.lua")

-- sign function
local function sign(x, default)
    if x < 0 then
        return -1
    elseif x > 0 then
        return 1
    end
    if default ~= nil then return default end
    return 0
end

-- some variables to name magic numbers
local quarter_circle = 0.5 * math.pi
local half_circle = 1.0 * math.pi
local full_circle = 2.0 * math.pi

-- how strong is the effect
local effect_magnitude = 2.0
-- how fast do we change the magnitude
local loop_speed = 20.0


local entity_id = GetUpdatedEntityID();
-- get velocity component, if not found there's no point in this
local velocity_comp = EntityGetFirstComponent( entity_id, "VelocityComponent")
if velocity_comp == nil then return end
-- get current projectile angle
local pos_x, pos_y, rad = EntityGetTransform( entity_id )
-- current velocities
local vel_x, vel_y = ComponentGetValue2(velocity_comp, "mVelocity")

-- get our t, start at either of the 0 points of a sin function
local t = GetValueNumber("t", Random(0, 1) * half_circle)
-- calculate magnitude
local offset_magnitude = math.sin(t * full_circle * loop_speed) * effect_magnitude
-- update t
SetValueNumber("t", t + 0.01)

-- calculate which direction is our starting direction
local function startdir(rad)
    -- left == -1, right == 1
    local horizontal = sign(math.abs(rad) - quarter_circle, 1)
    -- up == -1, down == 1
    local vertical = sign(rad, 1)
    local sum = horizontal + vertical
    -- sum 0 means we're in up right, or down left, which means we want angle dir 1
    -- sum -2 or 2 means we're in up left or down right, whcih means angle dir -1
    if (sum) == 0 then
        return 1
    else
        return -1
    end
end

-- get stored starting direction
local starting_direction = GetValueInteger("starting_direction", startdir(rad))

-- calculate a right angle (up or down)
-- flip based on the sign of offset_magnitude
local right_angle = starting_direction * quarter_circle * sign(offset_magnitude)

-- calculate the angle that's a right angle on the current angle of the projectile
local offset_angle = rad + right_angle

-- add velocity based on offset_angle * magnitude
vel_x = vel_x + math.cos(offset_angle) * offset_magnitude
vel_y = vel_y + math.sin(offset_angle) * offset_magnitude

-- set new velocity
ComponentSetValueVector2(velocity_comp, "mVelocity", vel_x, vel_y)
