--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    -- Set render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    EntityIdleState.update(self, dt)  -- Call the parent class's update function
end

function PlayerIdleState:update(dt)
    -- Check for input to transition to other states

    -- Transition to walk state if arrow keys are pressed
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    -- Transition to swing sword state if spacebar is pressed
    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')

    -- Check for interactions with objects in the room
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local room = self.dungeon.currentRoom

        local takenPot = nil
        local potIndex = 0

        -- Check for objects that can be interacted with
        for k, obj in pairs(room.objects) do
            if obj.takeable then
                -- Calculate positions for collision detection
                local playerXc = self.entity.x + self.entity.width / 2
                local playerYc = (self.entity.y + self.entity.height / 2) + (self.entity.height - self.entity.height / 2) / 2

                local playerCol = math.floor(playerXc / TILE_SIZE)
                local playerRow = math.floor(playerYc / TILE_SIZE)

                local objCol = math.floor((obj.x + obj.width / 2) / TILE_SIZE)
                local objRow = math.floor((obj.y + obj.height / 2) / TILE_SIZE)
                
                -- Check if player is adjacent to the object based on direction
                if (self.entity.direction == 'right') and (objRow == playerRow) and (objCol == (playerCol + 1)) or 
                (self.entity.direction == 'left') and (objRow == playerRow) and (objCol == (playerCol - 1)) or 
                (self.entity.direction == 'up') and (objCol == playerCol) and (objRow == (playerRow - 1)) or 
                (self.entity.direction == 'down') and (objCol == playerCol) and (objRow == (playerRow + 1)) then
                    takenPot = obj
                    potIndex = k
                    break
                end
                
            end
        end

        -- If an object is found, mark it as taken and transition to pot-lift state
        if takenPot ~= nil then
            table.remove(room.objects, potIndex)
            self.entity:changeState('pot-lift', {
                pot = takenPot
            })
        end
    end
end
