local function control(a,c)
	local dir=vector.direction(vector.components(a.x,a.y,a.target.x,a.target.y))
	local dist=vector.distance(a.x,a.y,a.target.x,a.target.y)
	if dist>a.speed then
		c.movehorizontal=math.cos(dir)
		c.movevertical=math.sin(dir)
	else
		a.speed=0
	end
	a.d=vector.direction(c.movehorizontal,-c.movevertical)
	a.vel=vector.length(c.movehorizontal,c.movevertical)*a.speed
end

return
{
	control = control,
}