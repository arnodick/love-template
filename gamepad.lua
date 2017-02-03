local function control(c)
	local deadzone=0.25

	c[1],c[2]=Joystick:getAxes()

	for i=1,2 do
		if c[i]>0 and c[i]<deadzone then
			c[i]=0
		end

		if c[i]<0 and c[i]>-deadzone then
			c[i]=0
		end
	end

	if Joystick:isDown(3) then
		c[3]=true
	end
	if Joystick:isDown(1) then
		c[4]=true
	end
end

return
{
	control = control,
}