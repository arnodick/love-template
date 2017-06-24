local function control(a,c)
	local j=Joysticks[1]
	local deadzone=0.25

	c.movehorizontal=j:getGamepadAxis("leftx")
	c.movevertical=j:getGamepadAxis("lefty")

	controller.deadzone(c,0.25)
end

return
{
	control = control,
}