local function make(a,c)
	a.destination={}
	a.destination.x=c.target.x
	a.destination.y=c.target.y
end

local function control(a,c)
	if a.destination then
		a.destination.x=c.target.x
		a.destination.y=c.target.y
		local dir=vector.direction(vector.components(a.x,a.y,a.destination.x,a.destination.y))
		local dist=vector.distance(a.x,a.y,a.destination.x,a.destination.y)
		if dist>a.speed then
			c.movehorizontal=math.cos(dir)
			c.movevertical=math.sin(dir)
		else
			c.movehorizontal=0
			c.movevertical=0
			a.destination=nil
		end
	end
end

return
{
	make = make,
	control = control,
}