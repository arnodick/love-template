local function control(a,c)
	local dir=vector.direction(vector.components(a.x,a.y,c.aim.target.x,c.aim.target.y))
	c.aimhorizontal=math.cos(dir)
	c.aimvertical=math.sin(dir)

	if love.math.random(20)==1 then
		c.shoot=true
	else
		c.shoot=false
	end
end

return
{
	control = control,
}