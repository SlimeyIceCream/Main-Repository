-- turn on if you just want the pearl, off if you want to use the full Blockbench model 
vanillaskin = false

if not vanillaskin then
	armor_model.HELMET.setEnabled(false)
	for key, value in pairs(vanilla_model) do
		value.setEnabled(false)
	end
else 
	model.Player.setEnabled(false)
end

SMOOTHNESS = 0.1 -- value between 0 and 1, the lower it is the smoother it gets
bend = 0.5
function playerLookDirAngle()
    local playerLookDir = player.getLookDir()
    local angle = -math.atan( playerLookDir[3] / playerLookDir[1] )

    -- we don't know if we are above or below 0 yet
    angle = angle * 180/math.pi - 90
    if 0 > playerLookDir[1] then
        angle = angle + 180
    end
    --return -180 to 180
    return angle
end

function getHeadRot()
    local x = vanilla_model.HEAD.getOriginRot()
    x = {x[1]*(180/math.pi),x[2]*(180/math.pi),0}
    return x
end

function clamp(value,low,high)
    return math.min(math.max(value, low), high)
end

function rad_to_degree(angle)
    return angle / math.pi * 360
end
function lerp(a, b, t)
    return a + ((b - a) * t)
end
function clamp(value,low,high)
    return math.min(math.max(value, low), high)
end
function tableLerp(a, b, x)
    return {clamp(lerp(a[1],b[1],x),-45,0),lerp(a[2],b[2],x),clamp(lerp(a[3],b[3],x),-30,30)}
end


function normalize(a)
    local len = math.sqrt(a[1]*a[1]+a[2]*a[2]+a[3]*a[3])
    return {a[1]/len,a[2]/len,a[3]/len}
end

function angleBetweenVectors(a,b)
    local aa = math.sqrt(a[1]*a[1]+a[2]*a[2]+a[3]*a[3])
    local bb = math.sqrt(b[1]*b[1]+b[2]*b[2]+b[3]*b[3])
    local ab = a[1]*b[1]+a[2]*b[2]+a[3]*b[3]
    return math.acos(ab/(aa*bb))
end
lastpos = player.getPos()
function movingForwardOrBackward()
    local vel = {player.getPos()[1] - lastpos[1], player.getPos()[2] - lastpos[2], player.getPos()[3] - lastpos[3]}
    vel = {vel[1],0,vel[3]}
    vel = normalize(vel)

    local dir = player.getLookDir()
    dir = {dir[1],0,dir[3]}
    dir = normalize(dir)

    local speed = vel[1]+vel[3]

    local angle = angleBetweenVectors(vel,dir)

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


-- ============== Variables ==============
lastHeadRot = getHeadRot()
lastHeadDir = playerLookDirAngle()
lastSpeed = 0
lastCapeRot = {0, 0, 0}
thirdCapeRot = {0, 0, 0}
bAdd = 0.2
bTime = 1
down = false
function clothPhysics()
    -- ============== Sideways rotation swinging ==============
    local headRot = getHeadRot()
    local headDir = playerLookDirAngle() + 180 -- add 180 so its between 0 and 360

    -- rotation difference from last tick
    local diff = lastHeadDir-headDir

    -- Fix glitchiness when going over the border from 0 to 360 or other direction
    -- Just check if diff is over 330 or something
    if diff > 330 or diff < -330 then
        diff = (360-lastHeadDir)-headDir
    end

    -- ============== Movement swinging ==============
    local velocity = player.getVelocity()
    local speed = math.sqrt(math.pow(velocity[1],2) + math.pow(velocity[3],2))*(-350)
    
    -- make diff dependent on speed
    diff = diff*(-speed/50)
    diff = clamp(diff, -45, 45)

    speed = clamp(lerp(lastSpeed,speed,0.3), -70, 0)

    -- check which direction the player is moving
    local moveDirection = movingForwardOrBackward()
    if moveDirection == "standing" then
        -- in this case the cape should not be rotated away from the player
        -- dont just set to 0, instead smooth transition
        speed = lastSpeed/2
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

    -- ============== Model rotations to apply in render() ==============
    capeRot = {speed, 0, diff}
    
    -- ============== Store for next tick ==============
    lastHeadRot = headRot
    lastHeadDir = headDir
    lastSpeed = speed
	thirdCapeRot = lastCapeRot
    lastCapeRot = capeRot
end
uvs = {}
uvs['turtle']    = {1/4,0}
uvs['leather']   = {0,1/5}
uvs['golden']    = {1/4,1/5}
uvs['chainmail'] = {1/4,2/5}
uvs['iron']      = {0,2/5}
uvs['diamond']   = {0,3/5}
uvs['netherite'] = {1/4,3/5}
function armor()
	helmet   = player.getEquipmentItem(6)
	chest   = player.getEquipmentItem(5)
	if uvs[armorType(helmet)] ~= nil then
		model.Player.Head.Top.Helmet.setEnabled(true)
		colorArmor(helmet)
		model.Player.Head.Top.Helmet.Helmet.setUV(uvs[armorType(helmet)])
	else
		model.Player.Head.Top.Helmet.setEnabled(false)
	end
	winged = (chest.getType() == "minecraft:elytra")
end

-- get armor type
function armorType(part)
  s = part.getType()
	if s ~= nil then
		i = string.find(s, ':')
		j = string.find(s, '_')
		if i ~= nil and j ~= nil then
			s = string.sub(s, i + 1, j - 1)
		end
	end
	return s
end

function colorArmor(part)
	if armorType(part) == 'leather' then
		model.Player.Head.Top.Helmet.Overlay.setEnabled(true)
		tag = part.getTag()
		if tag ~= nil then  
			local display = tag.display
			if display ~= nil then
				local dye = display.color
		  
				if dye ~= nil then
					local dyehex = (string.format("%x", dye))
					local dyergb = hex2rgb(dyehex)
					local red = dyergb[1]
					local green = dyergb[2]
					local blue= dyergb[3]
					model.Player.Head.Top.Helmet.Helmet.setColor({red /255, green /255, blue /255})
				end
			else
				model.Player.Head.Top.Helmet.Helmet.setColor({160 /255 , 101  /255 , 64  /255})
			end
		end
	else
		model.Player.Head.Top.Helmet.Overlay.setEnabled(false)
		model.Player.Head.Top.Helmet.Helmet.setColor({1,1,1})
	end
end

function hex2rgb(hex)
	hex = hex:gsub("#","")
	return {tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))}
end
hurtTicker = 0
lastHealth = 0
dead = false
function healthcheck()
	health = player.getHealth()
	if (health == 0 and not dead) then
		sound.playSound('entity.enderman.death',{playerPos.x,playerPos.y,playerPos.z,0.75,1})
		dead = true
	else
		if health < lastHealth then
			sound.playSound('entity.enderman.hurt',{playerPos.x,playerPos.y,playerPos.z,0.75,1})
			hurtTicker = 24
		end
	end
	if not vanillaskin then
		if hurtTicker ~= 0 then
			model.Player.Head.Top.setPos({0,-5,0})
			hurtTicker = hurtTicker - 1
		else
			model.Player.Head.Top.setPos({0,0,0})
		end
	end
	lastHealth = health
end

tag = 0
lastTag = 0
counter = 35
thrown = false
ticker = 0
lookdir = player.getBodyYaw()%360
lastdir = lookdir
sinwave = 3*math.sin(ticker/4)
lastsin = sinwave
function abilitycheck()
	nbt = player.getNbtValue("cardinal_components.origins:origin.Powers")
	for i, v in pairs(nbt) do
		if v["type"] == "origins:throw_ender_pearl" then
			tag = v["data"]
			if tag ~= lastTag then
				thrown = true
			end
			if thrown == true and counter < 35 then
				model.NO_PARENT.COMPANION.Orb.setEnabled(false)
				counter = counter + 1
			else
				if counter == 35 then
					model.NO_PARENT.COMPANION.Orb.setEnabled(true)
					counter = 0
					thrown = false
				end
			end
			lastTag = tag
			break
		end
	end
end
--NOTE: In order for this to work, you'll have to make a new folder inside of NO_PARENT called COMPANION with your model inside of it. If for some reason you can't name it COMPANION, just change the word COMPANION in line 46 to the name of your folder.
--Smoothing, lower is smoother
smooth = .05
--How far away the pearl should stay from the player, in blocks
playerDist = 1.25

-- how high up the pearl floats (in blocks + 1)
baseheight = 0.25

function multVec(a,b) return {a[1]*b[1], a[2]*b[2], a[3]*b[3]} end
function lerpVec(a,b,t) return {lerp(a[1],b[1],t), lerp(a[2],b[2],t), lerp(a[3],b[3],t)} end


modelPos = {0,0,0}
pathPos = {0,0,0}
pearlangle = math.rad(playerLookDirAngle() + 180)
xoffset = playerDist * math.sin(pearlangle)
zoffset = playerDist * math.cos(pearlangle)
function render(delta)
	  local targetPos = {player.getPos().x+finalx,player.getPos().y+(pearlheight),player.getPos().z+finalz}
	  pathPos = lerpVec(pathPos, targetPos, smooth)
	  model.NO_PARENT.COMPANION.setPos(multVec(pathPos, {-16, -16, 16}))
	  if not thrown then
		model.NO_PARENT.COMPANION.Orb.setPos({0,lerp(lastsin,sinwave,delta),0})
		model.NO_PARENT.COMPANION.Orb.setRot({0,ticker*4,0})
	end
end
state = false
crouch = false
crouchcounter = 0
crouchtimer = 0
function doublecrouch()
	if player.getAnimation() == "CROUCHING" then
		pearlheight = -0.5
		if not crouch then
			crouch = true
			if crouchcounter < 2 then
				crouchcounter = crouchcounter + 1
			end
		end
	else
		pearlheight = baseheight
		if crouch then
			crouch = false
		end
	end
	if ticker % 100 == 0 then
		if crouchcounter > 0 then
			crouchcounter = 0
		end
	end
	if crouchcounter == 2 then
		state = not state
		crouchcounter = 0
	end
	if state then
		pearlangle = math.rad(playerLookDirAngle() + 180)
		xoffset = playerDist * math.sin(pearlangle)
		zoffset = playerDist * math.cos(pearlangle)
		particle.addParticle("composter",{player.getPos().x+xoffset,player.getPos().y+1,player.getPos().z+zoffset,0,0,0})
	else 
		finalx = xoffset
		finalz = zoffset
	end
end
playerPos = player.getPos()
origin = player.getNbtValue("cardinal_components.origins:origin")
ender = ((origin["originlayers"][0]["origin"]) == "origins:enderian")
function tick()
	ticker = ticker + 1
	lastsin = sinwave
	lastpos = playerPos
	sinwave = 3*math.sin(ticker/4)
	playerPos = player.getPos()
	healthcheck()
	doublecrouch()
	if ender then
		abilitycheck()
	else
		if ticker % 2 == 0 then 
			particle.addParticle("portal",{playerPos.x+math.random(-10,10)/10,playerPos.y+math.random(0,10)/10,playerPos.z+math.random(-10,10)/10,0,0,0})
		end
	end
	if not vanillaskin then
		clothPhysics()
		armor()
	end
end

function render(delta)
	if not vanillaskin then
		if winged then
			model.Player.Body.Cape.setRot({0,0,0})
		else
			model.Player.Body.Cape.setRot(tableLerp(lastCapeRot, capeRot, delta/100000))
		end
		if (hurtTicker ~= 0 or health <= 5)then
			model.Player.setPos({math.random(-10,10)/100,0,math.random(-10,10)/100})
		end
	end
end
