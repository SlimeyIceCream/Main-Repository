cape_rotation = vectors.of({0,0,0}) -- This will contain the cape rotation at all times
use_custom_elytra = true -- Set this to false if you dont want to use the custom elytra

-- Calculate cape rotation - self contained, you dont have to change anything here
do
    local vectors_of = vectors.of
    local vectors_lerp = vectors.lerp
    local math_floor = math.floor
    local math_acos = math.acos
    local math_max = math.max
    local math_sin = math.sin
    local world_getTime = world.getTime
    local player_getPos = nil
    local player_getRot = nil
    local player_getLookDir = nil
    function player_init()
        player_getPos = player.getPos
        player_getRot = player.getRot
        player_getLookDir = player.getLookDir
    end

    local playervelocity = vectors_of({0,0,0})
    do
        local velocityPos = vectors_of({0,0,0})
        local lastVelocityPos = vectors_of({0,0,0})
        function tick()
            velocityPos = player_getPos()
            playervelocity = (velocityPos-lastVelocityPos)/1.8315
            lastVelocityPos = player_getPos()
        end
    end

    local function lerp(a, b, x)
        return a + (b - a) * x
    end

    local vel = vectors_of({0,0,0})

    local function move_direction()
        local veln = vel.normalized()
        local dir = player_getLookDir()
        dir = vectors_of({dir[1],0,dir[3]}).normalized()
        return veln.getLength() == 0 and 0 or math_floor(1+math_acos(veln.dot(dir))*1.4)
    end
    
    local headDir = 0
    local lastHeadDir = 0
    local speed = 0
    local lastSpeed = 0
    local capeRot = vectors_of({0,0,0})
    local lastCapeRot = vectors_of({0,0,0})
    
    local function capePhysics()
        vel = vectors_of({playervelocity[1],0,playervelocity[3]})
        
        lastHeadDir = headDir
        lastSpeed = speed
        lastCapeRot = capeRot

        headDir = -player_getRot().y
        local diff = lastHeadDir-headDir
        diff = diff*(-speed/50)

        if move_direction() > 3 then
            speed = math_sin(world_getTime()*1)*4-20 -- walk backwards animation
        else
            speed = math_max(lerp(lastSpeed,-vel.getLength()*350,0.3), -70) -- lerp for slowing down the cape
        end

        capeRot = vectors_of({speed, 0, diff})
    end
    elytra_model.LEFT_WING.setEnabled(not use_custom_elytra)
    elytra_model.RIGHT_WING.setEnabled(not use_custom_elytra)
    model.LEFT_ELYTRA.setEnabled(use_custom_elytra)
    model.RIGHT_ELYTRA.setEnabled(use_custom_elytra)
    function tick()
        capePhysics()
        local chestplate = player.getEquipmentItem(5).getType()
        model.TORSO.cape.setEnabled(not (chestplate == "minecraft:elytra"))
    end
    function render(delta)
        cape_rotation = vectors_lerp(lastCapeRot, capeRot, delta)
    end
end

-- Example usage
function render(delta)
    -- Apply cape physics to the cape
    model.TORSO.cape.setRot(cape_rotation)

    -- Apply cape physics to the elytra
    -- You can un-comment this to enable:

    --if player.getAnimation() ~= "FALL_FLYING" then
    --    model.LEFT_ELYTRA.self.setRot({cape_rotation.x, cape_rotation.x/3, cape_rotation.z})
    --    model.RIGHT_ELYTRA.self.setRot({cape_rotation.x, -cape_rotation.x/3, cape_rotation.z})
    --else
    --    model.LEFT_ELYTRA.self.setRot({0,0,0})
    --    model.RIGHT_ELYTRA.self.setRot({0,0,0})
    --end
end


