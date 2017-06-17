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

	if love.keyboard.isDown('z') then
		c.shoot=true
	else
		c.shoot=false
	end

	if love.keyboard.isDown('x') then
		c.action=true
	else
		c.action=false
	end
end

return
{
	control = control,
}