local function control(a,c)
	local dir=vector.direction(vector.components(a.x,a.y,c.target.x,c.target.y))
	c.aimhorizontal=math.cos(dir)
	c.aimvertical=math.sin(dir)

	if love.math.random( math.max(40-(a.rage*10),10) )==1 then
		c.shoot=true
	else
		c.shoot=false
	end
end

return
{
	control = control,
}