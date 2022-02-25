
lanturnX = 0
lanturnY = 0
lanturnZ = 0

function lerp(a, b, t)
    return a + (b - a) * t
end

function render(delta)

    --Makes the lanturn objects follow the player
    _x, _y, _z = player.getPos().x, player.getPos().y, player.getPos().z
    _x = _x * -16 
    _y = _y * -16 - 24
    _z = _z * 16

    spd = 0.05

    lanturnX = lerp(lanturnX, _x, spd)
    lanturnY = lerp(lanturnY, _y, spd) - math.sin(world.getTime()/4) * 0.25
    lanturnZ = lerp(lanturnZ, _z, spd)

    lanturn_pos = {lanturnX,lanturnY,lanturnZ}
    model.NO_PARENT.LANTURN.setPos(lanturn_pos)
    model.NO_PARENT.LANTURN.setRot({-20, lerp(model.NO_PARENT.LANTURN.getRot()[2], - player.getBodyYaw() -20, spd),0 })
end