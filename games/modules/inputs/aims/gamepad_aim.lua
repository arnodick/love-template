local function control(a,i)
	local j=Joysticks[1]
	local deadzone=0.25

	i.horizontal=j:getGamepadAxis("rightx")
	i.vertical=j:getGamepadAxis("righty")
end

return
{
	control = control,
}