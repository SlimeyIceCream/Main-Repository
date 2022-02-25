
--Variable to determine how extended the wings are from 1 (fully retracted) to 0 (fully extended)
--IDK why it's inverted but whatever
length = 0.0

pos = nil
_pos = nil
velocity = nil

function player_init()
    pos = player.getPos()
    _pos = pos
    velocity = vectors.of({0})
end


for key, value in pairs(elytra_model) do
    value.setEnabled(false)
end

function tick()
    
    _pos = pos
    pos = player.getPos()
    velocity = pos - _pos

    if player.getEquipmentItem(5).getType() == "minecraft:elytra" then
        model.Body.Jetpack.setEnabled(true)
        if player.getAnimation() == "FALL_FLYING" then
            length = 1/(1+math.exp((math.abs(velocity[2])-1)/-0.3))
        else
            length = 1.0
        end
    else
        model.Body.Jetpack.setEnabled(false)
    end
end

function render(delta)

    model.Body.Jetpack.RightWing.W1.setPos({(length*7.1  ), 0, 0})
    model.Body.Jetpack.RightWing.W2.setPos({(length*13.1 ), 0, 0})
    model.Body.Jetpack.RightWing.W3.setPos({(length*18.1 ), 0, 0})
    model.Body.Jetpack.RightWing.Tip.setPos({(length*18.1), 0, 0})

    model.Body.Jetpack.LeftWing.W1.setPos({(length*-7.1  ), 0, 0})
    model.Body.Jetpack.LeftWing.W2.setPos({(length*-13.1 ), 0, 0})
    model.Body.Jetpack.LeftWing.W3.setPos({(length*-18.1 ), 0, 0})
    model.Body.Jetpack.LeftWing.Tip.setPos({(length*-18.1), 0, 0})

end