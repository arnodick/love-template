local function control(a)
	local e=Enums.commands
	local c=a.controller

	local dir=vector.direction(vector.components(a.x,a.y,a.target.x,a.target.y))
	local dist=vector.distance(a.x,a.y,a.target.x,a.target.y)
	if dist<150 then
		c.movehorizontal=-math.cos(dir)
		c.movevertical=-math.sin(dir)
	else
		--c.movehorizontal=math.randomfraction(2)-1
		--c.movevertical=math.randomfraction(2)-1
		c.movehorizontal=0
		c.movevertical=0
	end
	a.d=vector.direction(c.movehorizontal,-c.movevertical)
	a.vel=vector.length(c.movehorizontal,c.movevertical)
end

return
{
	control = control,
}