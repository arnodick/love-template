local function control(a,c)
	a.vec[1]=0
	a.vec[2]=0

	c.movehorizontal=love.math.random(2)-1
	c.movevertical=love.math.random(2)-1

	controller.deadzone(c,0.25)

	if c.lasthorizontal==0 and c.lastvertical==0 then
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
		a.vec[1]=c.movehorizontal
		a.vec[2]=c.movevertical
	else
		a.vec[1]=0
		a.vec[2]=0
	end
end

return
{
	control = control,
}