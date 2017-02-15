local function control(a)
	local e=Enums.commands
	local c=a.controller

	local dir=vector.direction(vector.components(a.x,a.y,Cursor.x,Cursor.y))
	c[e.aimhorizontal]=math.cos(dir)
	c[e.aimvertical]=math.sin(dir)

	if love.mouse.isDown(1) then
		c[e.shoot]=true
	else
		c[e.shoot]=false
	end
	if love.mouse.isDown(2) then
		c[e.powerup]=true
	else
		c[e.powerup]=false
	end
end

return
{
	control = control,
}