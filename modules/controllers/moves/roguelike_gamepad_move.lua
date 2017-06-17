local function control(a,c)
	local j=Joysticks[1]
	local deadzone=0.25

	a.vec[1]=0
	a.vec[2]=0

	c.movehorizontal=j:getGamepadAxis("leftx")
	c.movevertical=j:getGamepadAxis("lefty")

	controller.deadzone(c,0.25)

	if c.lasthorizontal==0 and c.lastvertical==0 then
		if c.movehorizontal>0 then
			Game.step=true
			c.movehorizontal=1
			c.movevertical=0
		elseif c.movehorizontal<0 then
			Game.step=true
			c.movehorizontal=-1
			c.movevertical=0
		elseif c.movevertical>0 then
			Game.step=true
			c.movevertical=-1
			c.movehorizontal=0
		elseif c.movevertical<0 then
			Game.step=true
			c.movevertical=1
			c.movehorizontal=0
		end
		a.vec[1]=c.movehorizontal
		a.vec[2]=c.movevertical
	else
		Game.step=false
		a.vec[1]=0
		a.vec[2]=0
	end
end

return
{
	control = control,
}