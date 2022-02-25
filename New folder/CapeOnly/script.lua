
do
    -- Calculate player velocity
    local playervelocity = vectors.of({0,0,0})
    do
        local velocityPos = vectors.of({0,0,0})
        local lastVelocityPos = vectors.of({0,0,0})
        function tick()
            velocityPos = player.getPos()
            playervelocity = (velocityPos-lastVelocityPos)/1.8315
            lastVelocityPos = player.getPos()
        end
    end
    -- Helper Functions
    local function look_dir_angle()
        local playerLookDir = player.getLookDir()
        local angle = -math.atan( playerLookDir[3] / playerLookDir[1] )
    
        -- we don't know if we are above or below 0 yet
        angle = angle * 180/math.pi - 90
        if 0 > playerLookDir[1] then
            angle = angle + 180
        end
        --range from -180 to 180
        return angle
    end
    local function lerp(a, b, x)
        return a + (b - a) * x
    end
    local function lerp_3d(a, b, x)
        return vectors.of({lerp(a.x,b.x,x),lerp(a.y,b.y,x),lerp(a.z,b.z,x)})
    end
    local function clamp(value,low,high)
        return math.min(math.max(value, low), high)
    end
    local function angle(a,b)
        local aa = math.sqrt(a.x*a.x+a.y*a.y+a.z*a.z)
        local bb = math.sqrt(b.x*b.x+b.y*b.y+b.z*b.z)
        local ab = a.x*b.x+a.y*b.y+a.z*b.z
        return math.acos(ab/(aa*bb))
    end
    local function move_direction()
        local vel = playervelocity
        vel = vectors.of({vel[1],0,vel[3]})
        vel = vel.normalized()
    
        local dir = player.getLookDir()
        dir = vectors.of({dir[1],0,dir[3]})
        dir = dir.normalized()
    
        local speed = vel[1]+vel[3]
    
        local angle = angle(vel,dir)
    
        if speed == 0 or tostring(speed) == "nan" then
            return "standing"
        elseif math.floor(angle) == 0 then
            return "forward"
        elseif math.floor(angle) == 1 then
            return "sideways"
        else
            return "backward"
        end
    end
    
    local headDir = 0
    local lastHeadDir = 0
    local speed = 0
    local lastSpeed = 0
    local capeRot = vectors.of({0,0,0})
    local lastCapeRot = vectors.of({0,0,0})
    local bAdd = 0.2
    local bTime = 1
    -- Cape physics
    local function capePhysics()
        -- ============== Store for next tick ==============
        lastHeadDir = headDir
        lastSpeed = speed
        lastCapeRot = capeRot

        -- ============== Sideways rotation swinging ==============
        headDir = look_dir_angle() + 180 -- add 180 so its between 0 and 360

        -- rotation difference from last tick
        local diff = lastHeadDir-headDir

        -- Fix glitchiness when going over the border from 0 to 360 or other direction
        -- Just check if diff is over 330 or something
        if diff > 330 or diff < -330 then
            diff = (360-lastHeadDir)-headDir
        end

        -- ============== Movement swinging ==============
        speed = math.sqrt(math.pow(playervelocity.x,2) + math.pow(playervelocity.z,2))*(-350)
        
        -- make diff dependent on speed
        diff = diff*(-speed/50)
        diff = clamp(diff, -45, 45)

        speed = clamp(lerp(lastSpeed,speed,0.3), -70, 0)

        -- check which direction the player is moving
        local moveDirection = move_direction()
        if moveDirection == "standing" then
            -- in this case the cape should not be rotated away from the player
            -- dont just set to 0, instead smooth transition
            speed = lastSpeed
        elseif moveDirection == "backward" then
            -- in this case do a little swinging animation, like optifine does it
            speed = speed / bTime
            if bTime > 1.7 and bAdd == 0.2 then
                bAdd = -0.2
            elseif bTime < 1.4 and bAdd == -0.2 then
                bAdd = 0.2
            end
            bTime = bTime + bAdd
        end

        if player.getAnimation() == "SWIMMING" then
            speed = 0
        end

        -- ============== Model rotations to apply in render() ==============
        capeRot = vectors.of({speed, 0, diff})
    end
    
    function tick()
        capePhysics()
    end
    function render(delta)
        cape_rotation = lerp_3d(lastCapeRot, capeRot, delta)
        model.TORSO.CAPE.setRot(cape_rotation)
    end
end

-- color table
colors = {
    ["leather"]   = {106 /255 , 64  /255 , 41  /255}
  }
  
  function tick()
    -- armor
    armor()
  end
    -- get armor color
    function colorArmor(item)
        -- reset color
        colors["leather"] = {106 /255, 64 /255, 41 /255}
        
        -- get item color display tag
        local tag = item.getTag()
        if tag ~= nil and tag.display ~= nil and tag.display.color ~= nil then
          local rgb = vectors.intToRGB(tag.display.color)
          colors["leather"] = {rgb.r, rgb.g, rgb.b}
        end
    end
  -- armor
  function armor()
    -- set armor types
    local chestplateItem = player.getEquipmentItem(5)
    local leggingsItem   = player.getEquipmentItem(4)

    local chestplate = string.sub(chestplateItem.getType(), 11, -12)
    local leggings   = string.sub(leggingsItem.getType(),   11, -10)
    -- chestplate
    if colors[chestplate] ~= nil then
      -- color
      if chestplate == "leather" then
        colorArmor(player.getEquipmentItem(5))
      end
      model.TORSO.CAPE.UPPER.setColor(colors[chestplate])
    else
        model.TORSO.CAPE.UPPER.setColor(colors["leather"])
    end
    
    -- armor chestplate
    if (player.getEquipmentItem(5).getType() == "minecraft:elytra") then
        model.TORSO.CAPE.setEnabled(false)
    else
        model.TORSO.CAPE.setEnabled(true)
    end

    if (player.getEquipmentItem(5).getType() == "minecraft:leather_chestplate") then
        model.TORSO.CAPE.UPPER.setUV({0,0})
    elseif (player.getEquipmentItem(5).getType() == "minecraft:chainmail_chestplate") then
        model.TORSO.CAPE.UPPER.setColor({1,1,1})
        model.TORSO.CAPE.UPPER.setUV({-23/128,18/128})
    elseif (player.getEquipmentItem(5).getType() == "minecraft:golden_chestplate") then
        model.TORSO.CAPE.UPPER.setColor({1,1,1})
        model.TORSO.CAPE.UPPER.setUV({0,18/128})
    elseif (player.getEquipmentItem(5).getType() == "minecraft:iron_chestplate") then
        model.TORSO.CAPE.UPPER.setColor({1,1,1})
        model.TORSO.CAPE.UPPER.setUV({-46/128,36/128})
    elseif (player.getEquipmentItem(5).getType() == "minecraft:diamond_chestplate") then
        model.TORSO.CAPE.UPPER.setColor({1, 1, 1})
        model.TORSO.CAPE.UPPER.setUV({-23/128,36/128})
    elseif (player.getEquipmentItem(5).getType() == "minecraft:netherite_chestplate") then
        model.TORSO.CAPE.UPPER.setColor({1, 1, 1})
        model.TORSO.CAPE.UPPER.setUV({0,36/128})
    else
        model.TORSO.CAPE.UPPER.setColor({1, 1, 1})
        model.TORSO.CAPE.UPPER.setUV({-23/128,0})
    end
    -- leggings
    if colors[leggings] ~= nil then
      -- color
      if leggings == "leather" then
        colorArmor(player.getEquipmentItem(4))
      end
      model.TORSO.CAPE.LOWER.setColor(colors[leggings])
    else
        model.TORSO.CAPE.LOWER.setColor(colors["leather"])
    end
    -- armor leggings
    if (player.getEquipmentItem(4).getType() == "minecraft:leather_leggings") then
        model.TORSO.CAPE.LOWER.setUV({0,0})
    elseif (player.getEquipmentItem(4).getType() == "minecraft:chainmail_leggings") then
        model.TORSO.CAPE.LOWER.setColor({1,1,1})
        model.TORSO.CAPE.LOWER.setUV({-23/128,18/128})
    elseif (player.getEquipmentItem(4).getType() == "minecraft:golden_leggings") then
        model.TORSO.CAPE.LOWER.setColor({1, 1, 1})
        model.TORSO.CAPE.LOWER.setUV({0,18/128})
    elseif (player.getEquipmentItem(4).getType() == "minecraft:iron_leggings") then
        model.TORSO.WINGS.setColor({1, 1, 1})
        model.TORSO.CAPE.LOWER.setColor({1,1,1})
        model.TORSO.CAPE.LOWER.setUV({-46/128,36/128})
    elseif (player.getEquipmentItem(4).getType() == "minecraft:diamond_leggings") then
        model.TORSO.CAPE.LOWER.setColor({1, 1, 1})
        model.TORSO.CAPE.LOWER.setUV({-23/128,36/128})
    elseif (player.getEquipmentItem(4).getType() == "minecraft:netherite_leggings") then
        model.TORSO.CAPE.LOWER.setColor({1, 1, 1})
        model.TORSO.CAPE.LOWER.setUV({0,36/128})
    else
        model.TORSO.CAPE.LOWER.setColor({1, 1, 1})
        model.TORSO.CAPE.LOWER.setUV({-23/128,0})
    end
  end