local function control(a)
	local e=Enums.buttons
	local c=a.controller
	local deadzone=0.25

	c[e.leftstickhorizontal],
	c[e.leftstickvertical],
	c[e.lefttrigger],
	c[e.rightstickhorizontal],
	c[e.rightstickvertical],
	c[e.righttrigger]=Joystick:getAxes()

	for i=1,2 do
		if c[i]>0 and c[i]<deadzone then
			c[i]=0
		end

		if c[i]<0 and c[i]>-deadzone then
			c[i]=0
		end
	end

	if Joystick:isDown(3) or c[e.righttrigger]>0 then
		c[e.button1]=true
	else
		c[e.button1]=false
	end
	if Joystick:isDown(1) then
		c[e.button2]=true
	end
end

return
{
	control = control,
}