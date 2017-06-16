local function control(a,c)
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

	if c.movevertical<0 then
		if c.lastvertical>=0 then
			a.text.index=math.clamp(a.text.index-1,1,#a.text,true)
		end
	elseif c.movevertical>0 then
		if c.lastvertical<=0 then
			a.text.index=math.clamp(a.text.index+1,1,#a.text,true)
		end
	end
end

return
{
	control = control,
}