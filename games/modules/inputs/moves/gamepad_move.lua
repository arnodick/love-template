local function control(a,i)
	local j=Joysticks[1]
	local deadzone=0.25

	i.movehorizontal=j:getGamepadAxis("leftx")
	i.movevertical=j:getGamepadAxis("lefty")

	--controller.deadzone(c,0.25)
end

return
{
	control = control,
}