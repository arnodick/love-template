local function control(c)
	local deadzone=0.25

	c[Enums.buttons.leftstickhorizontal][1],
	c[Enums.buttons.leftstickvertical][1],
	c[Enums.buttons.lefttrigger][1],
	c[Enums.buttons.rightstickhorizontal][1],
	c[Enums.buttons.rightstickvertical][1],
	c[Enums.buttons.righttrigger][1]=Joystick:getAxes()

	for i=1,6 do
		if c[i][2] then
			if c[i][1]>0 and c[i][1]<deadzone then
				c[i][1]=0
			end

			if c[i][1]<0 and c[i][1]>-deadzone then
				c[i][1]=0
			end
		end
	end

	if Joystick:isDown(3) then
		c[Enums.buttons.button1][1]=true
	end
	if Joystick:isDown(1) then
		c[Enums.buttons.button2][1]=true
	end
end

return
{
	control = control,
}