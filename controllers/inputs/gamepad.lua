local function control(a)
	local e=Enums.commands
	local c=a.controller
	local j=Joysticks[1]
	local deadzone=0.25

	c.movehorizontal=j:getGamepadAxis("leftx")
	c.movevertical=j:getGamepadAxis("lefty")
	c.aimhorizontal=j:getGamepadAxis("rightx")
	c.aimvertical=j:getGamepadAxis("righty")

	local axes={"movehorizontal","movevertical"}
	for i=1,#axes do
		if c[axes[i]]>0 and c[axes[i]]<deadzone then
			c[axes[i]]=0
		end

		if c[axes[i]]<0 and c[axes[i]]>-deadzone then
			c[axes[i]]=0
		end
	end

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
	a.d=vector.direction(c.movehorizontal,-c.movevertical)
	a.vel=vector.length(c.movehorizontal,c.movevertical)
end

return
{
	control = control,
}