local function control(a)
	local e=Enums.commands
	local c=a.controller

	local dir=vector.direction(vector.components(a.x,a.y,a.target.x,a.target.y))
	local dist=vector.distance(a.x,a.y,a.target.x,a.target.y)
	if dist<150 then
		c[e.movehorizontal]=-math.cos(dir)
		c[e.movevertical]=-math.sin(dir)
	else
		--c[e.movehorizontal]=math.randomfraction(2)-1
		--c[e.movevertical]=math.randomfraction(2)-1
		c[e.movehorizontal]=0
		c[e.movevertical]=0
	end
end

return
{
	control = control,
}