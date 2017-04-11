local function control(a)
	local e=Enums.commands
	local c=a.controller

	local dir=vector.direction(vector.components(a.x,a.y,a.cursor.x,a.cursor.y))
	c.aimhorizontal=math.cos(dir)
	c.aimvertical=math.sin(dir)

	if love.mouse.isDown(1) then
		c.shoot=true
	else
		c.shoot=false
	end
	if love.mouse.isDown(2) then
		c.powerup=true
	else
		c.powerup=false
	end
end

return
{
	control = control,
}