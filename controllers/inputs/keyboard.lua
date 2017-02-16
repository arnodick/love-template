local function control(a)
	local e=Enums.commands
	local c=a.controller

	if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
		c[e.movehorizontal]=-1
	elseif love.keyboard.isDown('right') or love.keyboard.isDown('d')  then
		c[e.movehorizontal]=1
	else
		c[e.movehorizontal]=0
	end

	if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
		c[e.movevertical]=-1
	elseif love.keyboard.isDown('down') or love.keyboard.isDown('s') then
		c[e.movevertical]=1
	else
		c[e.movevertical]=0
	end

	if love.keyboard.isDown('z') then
		c[e.shoot]=true
	else
		c[e.shoot]=false
	end

	if love.keyboard.isDown('x') then
		c[e.powerup]=true
	else
		c[e.powerup]=false
	end
	a.d=vector.direction(c[e.movehorizontal],-c[e.movevertical])
	a.vel=vector.length(c[e.movehorizontal],c[e.movevertical])
end

return
{
	control = control,
}