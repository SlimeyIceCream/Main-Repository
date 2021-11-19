-- do you want your character to wear a collar?
collar = true

-- default collar color (RGB value)
collarcolor = {150 /255 ,20/255 ,0/255}

-- camera moves down to your shorter cat height. this is experimental and kinda messes with aiming.
camerashift = true
-- ======================================
camera.THIRD_PERSON.setPos({0,-1,0})
for key, value in pairs(vanilla_model) do
    value.setEnabled(false)    
end
for key, value in pairs(armor_model) do
    value.setEnabled(false)    
end
for key, value in pairs(elytra_model) do
    value.setEnabled(false)    
end

model.body.belly.collar.setEnabled(collar)

colors = {}
colors['turtle']    = {71  /255 , 191 /255 , 74  /255}
colors['leather']   = {106 /255 , 64  /255 , 41  /255}
colors['golden']    = {255 /255 , 240 /255 , 90  /255}
colors['chainmail'] = {180 /255 , 180 /255 , 180 /255}
colors['iron']      = {229 /255 , 229 /255 , 229 /255}
colors['diamond']   = {107 /255 , 243 /255 , 227 /255}
colors['netherite'] = {81  /255 , 68  /255 , 78  /255}

function armor()
	helmet   = player.getEquipmentItem(6)
	if helmet.hasGlint() then
		model.body.belly.collar.setShader("Glint")
	else
		model.body.belly.collar.setShader("None")
	end
	if colors[armorType(helmet)] ~= nil then
		colorArmor(helmet)
		model.body.belly.collar.setColor(colors[armorType(helmet)])
	else
		model.body.belly.collar.setColor(collarcolor)
	end
end

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
		colors['leather']   = {106 /255 , 64  /255 , 41  /255}
	end
  
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
				colors['leather'] = {red /255, green /255, blue /255}
			end
		end
	end
end

function hex2rgb(hex)
	hex = hex:gsub("#","")
	return {tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))}
end

lastHealth = 0
dead = false
function healthcheck()
	health = player.getHealth()
	if (health == 0 and not dead) then
		sound.playSound('entity.cat.death',{playerPos.x,playerPos.y,playerPos.z,0.75,1})
		dead = true
	else
		if health < lastHealth then
			sound.playSound('entity.cat.hurt',{playerPos.x,playerPos.y,playerPos.z,0.75,1})
		else
			if health == player.getMaxHealth() then
				dead = false
			end
		end
	end
	lastHealth = health
end

function clamp(value,low,high)
    return math.min(math.max(value, low), high)
end

function lerp(a, b, x)
    return a + (b - a) * x
end

function tableLerp(a, b, x)
    return {lerp(a[1],b[1],x),lerp(a[2],b[2],x),clamp(lerp(a[3],b[3],x),-45,45)}
end

-- apologies, this code is a mess
ticker = 0
tailsin = 0
finalangle = 0
lastpos = player.getPos()

function cameramove()
	if camerashift then
		if anim == "SWIMMING" or anim == "FALL_FLYING" then
			camera.FIRST_PERSON.setPos({0,0.1,0})
		else
			camera.FIRST_PERSON.setPos({0,-1,0})
		end
	else
		camera.FIRST_PERSON.setPos({0,0,0})
	end
end

function tick()
	playerPos = player.getPos()
	healthcheck()
	anim = player.getAnimation()
	cameramove()
	
	if collar then
		armor()
	end
	
	velocity = vectors.of{player.getPos()[1] - lastpos[1], player.getPos()[2] - lastpos[2], player.getPos()[3] - lastpos[3]}
	lastpos = player.getPos()
	speed = math.abs(math.sqrt(math.pow(velocity[1],2) + math.pow(velocity[2],2) + math.pow(velocity[3],2)))*0.9
	speed = clamp(speed,0,1)
	
	ticker = ticker + 1
	tailsin = 15*math.sin(ticker/10)
	
	winged = (player.getEquipmentItem(5)).getType() == "minecraft:elytra"
	model.body.belly.wings.setEnabled(winged)
	if winged and anim == "FALL_FLYING" then
		model.body.belly.wings.LW.setRot({lerp(0,-10,speed),0,lerp(-20,-85,speed)})
		model.body.belly.wings.RW.setRot({lerp(0,-10,speed),0,lerp(20,85,speed)})
	else
		model.body.belly.wings.LW.setRot({0,5,-20})
		model.body.belly.wings.RW.setRot({0,-5,20})
	end
	
	if anim == "CROUCHING" then
		bodyangle = 45
		multiplier = 1
		model.body.head.setPos({0,2,0})
		model.body.frontLegR.setPos({0,4,-1})
		model.body.frontLegL.setPos({0,4,-1})
		model.body.backLegR.setPos({0,0.5,-1.5})
		model.body.backLegL.setPos({0,0.5,-1.5})
		tailangle = -145
		tail2angle = -55
		frontlegangle = 37.5
		backlegangle = -45
		headangle = 45
		allowance = 0
	else
		if anim == "FALL_FLYING" then
			bodyangle = 90
			headangle = 45
			multiplier = 1
			frontlegangle = 25
			backlegangle = 30
		else
			if anim == "SWIMMING" then
				bodyangle = 90
				headangle = 45
				multiplier = 3
			else
				bodyangle = 0
				headangle = 0
				multiplier = 1
			end
			frontlegangle = 0
			backlegangle = 0
		end
		model.body.frontLegR.setPos({0,0,0})
		model.body.frontLegL.setPos({0,0,0})
		model.body.backLegR.setPos({0,0,0})
		model.body.backLegL.setPos({0,0,0})
		model.body.head.setPos({0,0,0})
		tailangle = -45
		tail2angle = -45
		allowance = 1
		tailsin = 0
	end
	model.body.setRot({bodyangle,0,0})
end
tail1 = 0
function render(delta)
	head = {-math.deg(vanilla_model.HEAD.getOriginRot()[1])-headangle,-math.deg(vanilla_model.HEAD.getOriginRot()[2])*allowance,-math.deg(vanilla_model.HEAD.getOriginRot()[3])}
	backR = math.deg((vanilla_model.RIGHT_LEG.getOriginRot()[1]))/2.5*multiplier - backlegangle
	backL = math.deg((vanilla_model.LEFT_LEG.getOriginRot()[1]))/2.5*multiplier - backlegangle
	frontR = math.deg((vanilla_model.LEFT_LEG.getOriginRot()[1]))/3*multiplier - frontlegangle
	frontL = math.deg((vanilla_model.RIGHT_LEG.getOriginRot()[1]))/3*multiplier - frontlegangle
	tail2 = math.deg((vanilla_model.RIGHT_LEG.getOriginRot()[1]))/5 + tail2angle 
	model.body.head.setRot(head)
	model.body.frontLegR.setRot({frontR,0,0})
	model.body.backLegR.setRot({backR,0,0})
	model.body.frontLegL.setRot({frontL,0,0})
	model.body.backLegL.setRot({backL,0,0})
	model.body.tail1.setRot({tailangle,0,0})
	model.body.tail1.tail2.setRot({tail2,0,tailsin/2})
end