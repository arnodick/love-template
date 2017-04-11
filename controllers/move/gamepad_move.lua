local function control(a)
	local c=a.controller
	local j=Joysticks[1]
	local deadzone=0.25

	c.movehorizontal=j:getGamepadAxis("leftx")
	c.movevertical=j:getGamepadAxis("lefty")

	local axes={"movehorizontal","movevertical"}
	for i=1,#axes do
		if c[axes[i]]>0 and c[axes[i]]<deadzone then
			c[axes[i]]=0
		end

		if c[axes[i]]<0 and c[axes[i]]>-deadzone then
			c[axes[i]]=0
		end
	end

	a.d=vector.direction(c.movehorizontal,-c.movevertical)
	a.vel=vector.length(c.movehorizontal,c.movevertical)
end

return
{
	control = control,
}