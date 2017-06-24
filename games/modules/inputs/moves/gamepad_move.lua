local function control(a,i)
	local j=Joysticks[1]
	local deadzone=0.25

	i.horizontal=j:getGamepadAxis("leftx")
	i.vertical=j:getGamepadAxis("lefty")

	--controller.deadzone(c,0.25)
end

return
{
	control = control,
}