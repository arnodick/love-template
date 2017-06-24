local function control(a,c)
	local dir=vector.direction(vector.components(a.x,a.y,c.target.x,c.target.y))
	c.aimhorizontal=math.cos(dir)
	c.aimvertical=math.sin(dir)
end

return
{
	control = control,
}