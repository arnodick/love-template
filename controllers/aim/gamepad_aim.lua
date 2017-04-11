local function control(a)
	local c=a.controller
	local j=Joysticks[1]
	local deadzone=0.25

	c.aimhorizontal=j:getGamepadAxis("rightx")
	c.aimvertical=j:getGamepadAxis("righty")

	if j:isDown(3) or j:getGamepadAxis("triggerright")>0 then
		c.shoot=true
	else
		c.shoot=false
	end
	if j:isDown(1) or j:getGamepadAxis("triggerleft")>0 then
		c.powerup=true
	else
		c.powerup=false
	end
end

return
{
	control = control,
}