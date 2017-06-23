local function control(a,c)
	if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
		c.movehorizontal=-1
	elseif love.keyboard.isDown('right') or love.keyboard.isDown('d')  then
		c.movehorizontal=1
	else
		c.movehorizontal=0
	end

	if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
		c.movevertical=-1
	elseif love.keyboard.isDown('down') or love.keyboard.isDown('s') then
		c.movevertical=1
	else
		c.movevertical=0
	end

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