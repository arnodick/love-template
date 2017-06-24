local function control(a,c)
	local dir=vector.direction(vector.components(a.x,a.y,a.cursor.x,a.cursor.y))
	c.aimhorizontal=math.cos(dir)
	c.aimvertical=math.sin(dir)
end

return
{
	control = control,
}