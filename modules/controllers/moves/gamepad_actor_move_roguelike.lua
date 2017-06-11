local function control(a,c)
	local j=Joysticks[1]
	local deadzone=0.25

	a.vec[1]=0
	a.vec[2]=0

	c.movehorizontal=j:getGamepadAxis("leftx")
	c.movevertical=j:getGamepadAxis("lefty")

	controller.deadzone(c,0.25)

	if c.movehorizontal>0 then
		c.movehorizontal=1
		c.movevertical=0
	elseif c.movehorizontal<0 then
		c.movehorizontal=-1
		c.movevertical=0
	elseif c.movevertical>0 then
		c.movevertical=-1
		c.movehorizontal=0
	elseif c.movevertical<0 then
		c.movevertical=1
		c.movehorizontal=0
	end

	a.d=vector.direction(c.movehorizontal,-c.movevertical)
	a.vel=vector.length(c.movehorizontal,c.movevertical)

	a.vec[1]=c.movehorizontal
	a.vec[2]=c.movevertical
end

return
{
	control = control,
}