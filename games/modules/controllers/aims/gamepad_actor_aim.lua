local function control(a,c)
	local j=Joysticks[1]
	local deadzone=0.25

	c.aimhorizontal=j:getGamepadAxis("rightx")
	c.aimvertical=j:getGamepadAxis("righty")
end

return
{
	control = control,
}