local function control(a,c)
	local j=Joysticks[1]
	local deadzone=0.25

	c.movehorizontal=j:getGamepadAxis("leftx")
	c.movevertical=j:getGamepadAxis("lefty")

	controller.deadzone(c,0.5)

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
	else
		Game.step=false
	end
end

return
{
	control = control,
}