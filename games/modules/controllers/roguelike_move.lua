local function control(a,c)
	local i=a.input.move
	
	c.movehorizontal=i.horizontal
	c.movevertical=i.vertical

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