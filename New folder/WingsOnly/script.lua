-- disables Elytra Texture
elytra_model.LEFT_WING.setEnabled(false) 
elytra_model.RIGHT_WING.setEnabled(false)

SMOOTHNESS = 0.1 -- value between 0 and 1, the lower it is the smoother it gets
flight = false

function tick()
	if player.getAnimation() == "FALL_FLYING" then
        flight = true
    else
        flight = false
    end

	-- Is player wearing Elytra
	if (player.getEquipmentItem(5).getType() ~= "minecraft:elytra") then
        model.TORSO.WINGS.LEFT_WING.setEnabled(false)
        model.TORSO.WINGS.LEFT_WING.LEFT_WING_TWO.setEnabled(false)
		model.TORSO.WINGS.LEFT_WING.LEFT_WING_TWO.LEFT_WING_THREE.setEnabled(false)
		model.TORSO.WINGS.LEFT_WING.LEFT_WING_TWO.LEFT_WING_THREE.four.setEnabled(false)

		model.TORSO.WINGS.RIGHT_WING.setEnabled(false)
        model.TORSO.WINGS.RIGHT_WING.RIGHT_WING_TWO.setEnabled(false)
		model.TORSO.WINGS.RIGHT_WING.RIGHT_WING_TWO.RIGHT_WING_THREE.setEnabled(false)
		model.TORSO.WINGS.RIGHT_WING.RIGHT_WING_TWO.RIGHT_WING_THREE.four.setEnabled(false)
		

		model.TORSO.WINGS.LEFT_WING_FOLDED.setEnabled(false)
        model.TORSO.WINGS.LEFT_WING_FOLDED.LEFT_WING_FOLDED_TWO.setEnabled(false)
		model.TORSO.WINGS.LEFT_WING_FOLDED.LEFT_WING_FOLDED_TWO.LEFT_WING_FOLDED_THREE.setEnabled(false)
		model.TORSO.WINGS.LEFT_WING_FOLDED.LEFT_WING_FOLDED_TWO.LEFT_WING_FOLDED_THREE.four.setEnabled(false)

		model.TORSO.WINGS.RIGHT_WING_FOLDED.setEnabled(false)
        model.TORSO.WINGS.RIGHT_WING_FOLDED.RIGHT_WING_FOLDED_TWO.setEnabled(false)
		model.TORSO.WINGS.RIGHT_WING_FOLDED.RIGHT_WING_FOLDED_TWO.RIGHT_WING_FOLDED_THREE.setEnabled(false)
		model.TORSO.WINGS.RIGHT_WING_FOLDED.RIGHT_WING_FOLDED_TWO.RIGHT_WING_FOLDED_THREE.four.setEnabled(false)
	else
		model.TORSO.WINGS.LEFT_WING_FOLDED.setEnabled(true)
        model.TORSO.WINGS.LEFT_WING_FOLDED.LEFT_WING_FOLDED_TWO.setEnabled(true)
		model.TORSO.WINGS.LEFT_WING_FOLDED.LEFT_WING_FOLDED_TWO.LEFT_WING_FOLDED_THREE.setEnabled(true)
		model.TORSO.WINGS.LEFT_WING_FOLDED.LEFT_WING_FOLDED_TWO.LEFT_WING_FOLDED_THREE.four.setEnabled(true)

		model.TORSO.WINGS.RIGHT_WING_FOLDED.setEnabled(true)
        model.TORSO.WINGS.RIGHT_WING_FOLDED.RIGHT_WING_FOLDED_TWO.setEnabled(true)
		model.TORSO.WINGS.RIGHT_WING_FOLDED.RIGHT_WING_FOLDED_TWO.RIGHT_WING_FOLDED_THREE.setEnabled(true)
		model.TORSO.WINGS.RIGHT_WING_FOLDED.RIGHT_WING_FOLDED_TWO.RIGHT_WING_FOLDED_THREE.four.setEnabled(true)
	end

    if not flight then
		model.TORSO.WINGS.LEFT_WING_FOLDED.setRot({0, 30-math.sin(world.getTime()/4)*10, 0})
        model.TORSO.WINGS.LEFT_WING_FOLDED.LEFT_WING_FOLDED_TWO.setRot({0, -math.sin(world.getTime()/4)*10, 0})
        model.TORSO.WINGS.LEFT_WING_FOLDED.LEFT_WING_FOLDED_TWO.LEFT_WING_FOLDED_THREE.setRot({0, -math.sin(world.getTime()/4)*10, 0})
        model.TORSO.WINGS.LEFT_WING_FOLDED.LEFT_WING_FOLDED_TWO.LEFT_WING_FOLDED_THREE.four.setRot({0, -math.sin(world.getTime()/4)*10, 0})
		
        model.TORSO.WINGS.RIGHT_WING_FOLDED.setRot({0, -30+math.sin(world.getTime()/4)*10, 0})
        model.TORSO.WINGS.RIGHT_WING_FOLDED.RIGHT_WING_FOLDED_TWO.setRot({0, math.sin(world.getTime()/4)*10, 0})
        model.TORSO.WINGS.RIGHT_WING_FOLDED.RIGHT_WING_FOLDED_TWO.RIGHT_WING_FOLDED_THREE.setRot({0, math.sin(world.getTime()/4)*10, 0})
        model.TORSO.WINGS.RIGHT_WING_FOLDED.RIGHT_WING_FOLDED_TWO.RIGHT_WING_FOLDED_THREE.four.setRot({0, math.sin(world.getTime()/4)*10, 0})
    end
end

function render(delta)
    if flight then
		model.TORSO.WINGS.LEFT_WING.setEnabled(true)
        model.TORSO.WINGS.LEFT_WING.LEFT_WING_TWO.setEnabled(true)
		model.TORSO.WINGS.LEFT_WING.LEFT_WING_TWO.LEFT_WING_THREE.setEnabled(true)
		model.TORSO.WINGS.LEFT_WING.LEFT_WING_TWO.LEFT_WING_THREE.four.setEnabled(true)

		model.TORSO.WINGS.RIGHT_WING.setEnabled(true)
        model.TORSO.WINGS.RIGHT_WING.RIGHT_WING_TWO.setEnabled(true)
		model.TORSO.WINGS.RIGHT_WING.RIGHT_WING_TWO.RIGHT_WING_THREE.setEnabled(true)
		model.TORSO.WINGS.RIGHT_WING.RIGHT_WING_TWO.RIGHT_WING_THREE.four.setEnabled(true)
		

		model.TORSO.WINGS.LEFT_WING_FOLDED.setEnabled(false)
        model.TORSO.WINGS.LEFT_WING_FOLDED.LEFT_WING_FOLDED_TWO.setEnabled(false)
		model.TORSO.WINGS.LEFT_WING_FOLDED.LEFT_WING_FOLDED_TWO.LEFT_WING_FOLDED_THREE.setEnabled(false)
		model.TORSO.WINGS.LEFT_WING_FOLDED.LEFT_WING_FOLDED_TWO.LEFT_WING_FOLDED_THREE.four.setEnabled(false)

		model.TORSO.WINGS.RIGHT_WING_FOLDED.setEnabled(false)
        model.TORSO.WINGS.RIGHT_WING_FOLDED.RIGHT_WING_FOLDED_TWO.setEnabled(false)
		model.TORSO.WINGS.RIGHT_WING_FOLDED.RIGHT_WING_FOLDED_TWO.RIGHT_WING_FOLDED_THREE.setEnabled(false)
		model.TORSO.WINGS.RIGHT_WING_FOLDED.RIGHT_WING_FOLDED_TWO.RIGHT_WING_FOLDED_THREE.four.setEnabled(false)
		
        model.TORSO.WINGS.LEFT_WING.setRot({0, 30-math.sin(world.getTime()/4)*20, 0})
        model.TORSO.WINGS.LEFT_WING.LEFT_WING_TWO.setRot({0, -math.sin(world.getTime()/4)*20, 0})
        model.TORSO.WINGS.LEFT_WING.LEFT_WING_TWO.LEFT_WING_THREE.setRot({0, -math.sin(world.getTime()/4)*20, 0})
        model.TORSO.WINGS.LEFT_WING.LEFT_WING_TWO.LEFT_WING_THREE.four.setRot({0, -math.sin(world.getTime()/4)*20, 0})
    
        model.TORSO.WINGS.RIGHT_WING.setRot({0, -30+math.sin(world.getTime()/4)*20, 0})
        model.TORSO.WINGS.RIGHT_WING.RIGHT_WING_TWO.setRot({0, math.sin(world.getTime()/4)*20, 0})
        model.TORSO.WINGS.RIGHT_WING.RIGHT_WING_TWO.RIGHT_WING_THREE.setRot({0, math.sin(world.getTime()/4)*20, 0})
        model.TORSO.WINGS.RIGHT_WING.RIGHT_WING_TWO.RIGHT_WING_THREE.four.setRot({0, math.sin(world.getTime()/4)*20, 0})
    else
        model.TORSO.WINGS.LEFT_WING.setEnabled(false)
        model.TORSO.WINGS.LEFT_WING.LEFT_WING_TWO.setEnabled(false)
		model.TORSO.WINGS.LEFT_WING.LEFT_WING_TWO.LEFT_WING_THREE.setEnabled(false)
		model.TORSO.WINGS.LEFT_WING.LEFT_WING_TWO.LEFT_WING_THREE.four.setEnabled(false)

		model.TORSO.WINGS.RIGHT_WING.setEnabled(false)
        model.TORSO.WINGS.RIGHT_WING.RIGHT_WING_TWO.setEnabled(false)
		model.TORSO.WINGS.RIGHT_WING.RIGHT_WING_TWO.RIGHT_WING_THREE.setEnabled(false)
		model.TORSO.WINGS.RIGHT_WING.RIGHT_WING_TWO.RIGHT_WING_THREE.four.setEnabled(false)
    end
end