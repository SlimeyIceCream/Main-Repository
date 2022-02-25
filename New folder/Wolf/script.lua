-- Made By Tully #2697 --
for key, value in pairs(vanilla_model) do
	value.setEnabled(false)
end

for key, value in pairs(armor_model) do
	value.setEnabled(false)
end

for key, value in pairs(elytra_model) do
	value.setEnabled(false)
end

hname = false

nametag = item_stack.createItem("minecraft:name_tag")

action_wheel.SLOT_1.setItem(nametag)
action_wheel.SLOT_1.setTitle("Hide Nametag")
action_wheel.SLOT_1.setFunction(function()
	hname = not hname
	if hname == true then
		nameplate.ENTITY.setEnabled(false)
		action_wheel.SLOT_1.setTitle("Show Nametag")
		action_wheel.SLOT_1.setItem(nametag)
	else
		nameplate.ENTITY.setEnabled(true)
		action_wheel.SLOT_1.setTitle("Hide Nametag")
		action_wheel.SLOT_1.setItem(nametag)
	end
end)