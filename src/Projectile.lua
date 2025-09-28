--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{}

function Projectile:init(obj, direction)
    self.obj = obj
    self.direction = direction
    self.distance = 0
    self.dead = false
end

function Projectile:update(dt)
    if self.dead then
        return -- No need to update if the projectile is dead
    end

    local add_distance = PROJECTILE_SPEED * dt
    
    if self.direction == 'up' then
        -- Move the object up
        self.obj.y = self.obj.y - add_distance
        -- Check if the projectile has reached the top of the map
        if self.obj.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.obj.height / 2 then 
            -- Adjust position and mark as dead
            self.obj.y = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.obj.height / 2
            self.dead = true
        end
    elseif self.direction == 'down' then
        -- Move the object down
        self.obj.y = self.obj.y + add_distance
        -- Calculate the bottom boundary of the map
        local bottom = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
            + MAP_RENDER_OFFSET_Y - TILE_SIZE
        -- Check if the projectile has reached the bottom of the map
        if self.obj.y + self.obj.height >= bottom then
            -- Adjust position and mark as dead
            self.obj.y = bottom - self.obj.height
            self.dead = true
        end
    elseif self.direction == 'left' then
        -- Move the object left
        self.obj.x = self.obj.x - add_distance
        -- Check if the projectile has reached the left edge of the map
        if self.obj.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then 
            -- Adjust position and mark as dead
            self.obj.x = MAP_RENDER_OFFSET_X + TILE_SIZE
            self.dead = true
        end
    elseif self.direction == 'right' then
        -- Move the object right
        self.obj.x = self.obj.x + add_distance
        -- Check if the projectile has reached the right edge of the map
        if self.obj.x + self.obj.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
            -- Adjust position and mark as dead
            self.obj.x = VIRTUAL_WIDTH - TILE_SIZE * 2 - self.obj.width
            self.dead = true
        end
    end

    if self.dead then
        return -- No need to update further if the projectile is dead
    end

    self.distance = self.distance + add_distance

    if self.distance > PROJECTILE_MAX_TILES * TILE_SIZE then
        self.dead = true -- Mark as dead if it has traveled beyond maximum distance
    end
end

function Projectile:render()
    self.obj:render(0, 0) -- Render the object at its current position
end

function Projectile:collides(target)
    -- Check if the projectile collides with the target object
    return not (self.obj.x + self.obj.width < target.x or self.obj.x > target.x + target.width or
                self.obj.y + self.obj.height < target.y or self.obj.y > target.y + target.height)
end
