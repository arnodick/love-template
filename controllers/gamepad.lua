local function control(a)
	local e=Enums.commands
	local c=a.controller
	local j=Joysticks[1]
	local deadzone=0.25

	c[e.movehorizontal]=j:getGamepadAxis("leftx")
	c[e.movevertical]=j:getGamepadAxis("lefty")
	c[e.aimhorizontal]=j:getGamepadAxis("rightx")
	c[e.aimvertical]=j:getGamepadAxis("righty")

	for i=1,2 do
		if c[i]>0 and c[i]<deadzone then
			c[i]=0
		end

		if c[i]<0 and c[i]>-deadzone then
			c[i]=0
		end
	end

	if j:isDown(3) or j:getGamepadAxis("triggerright")>0 then
		c[e.shoot]=true
	else
		c[e.shoot]=false
	end
	if j:isDown(1) or j:getGamepadAxis("triggerleft")>0 then
		c[e.powerup]=true
	else
		c[e.powerup]=false
	end
end

return
{
	control = control,
}