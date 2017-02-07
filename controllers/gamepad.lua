local function control(a,gs)
	local deadzone=0.25
	local c={0,0,0,0,0,0,false,false}
	local e=Enums.buttons

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

	Game.speed=(c[e.lefttrigger]+1)/2
	a.d=vector.direction(c[e.leftstickhorizontal],-c[e.leftstickvertical])
	a.vel=vector.length(c[e.leftstickhorizontal],c[e.leftstickvertical])

	if Joystick:isDown(3) or c[Enums.buttons.righttrigger]>0 then
		c[e.button1]=true
	end
	if Joystick:isDown(1) then
		c[e.button2]=true
	end

	if a.gun then
		gun.control(a.gun,gs,a,c[e.rightstickhorizontal],c[e.rightstickvertical],c[e.button1])
	end
end

return
{
	control = control,
}