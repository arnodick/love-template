local function control(c)
	local deadzone=0.25
	local e=Enums.buttons

	c[Enums.buttons.leftstickhorizontal],
	c[Enums.buttons.leftstickvertical],
	c[Enums.buttons.lefttrigger],
	c[Enums.buttons.rightstickhorizontal],
	c[Enums.buttons.rightstickvertical],
	c[Enums.buttons.righttrigger]=Joystick:getAxes()

---[[
	for i=1,2 do
		if c[i]>0 and c[i]<deadzone then
			c[i]=0
		end

		if c[i]<0 and c[i]>-deadzone then
			c[i]=0
		end
	end
--]]

	if Joystick:isDown(3) or c[Enums.buttons.righttrigger]>0 then
		c[Enums.buttons.button1]=true
	end
	if Joystick:isDown(1) then
		c[Enums.buttons.button2]=true
	end
---[[

	--a.x = a.x + a.controller[e.leftstickhorizontal]
	--a.y = a.y + a.controller[e.leftstickvertical]
--]]
end

return
{
	control = control,
}