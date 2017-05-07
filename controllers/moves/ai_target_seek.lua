local function make(a,c)
	a.destination={}
	a.destination.x=a.target.x
	a.destination.y=a.target.y
end

local function control(a,c)
	if a.destination then
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
		a.d=vector.direction(c.movehorizontal,-c.movevertical)
		a.vel=vector.length(c.movehorizontal,c.movevertical)
	end

--[[
		local movedir=vector.direction(vector.components(a.x,a.y,a.destination.x,a.destination.y))
		c.movehorizontal=math.cos(movedir)
		c.movevertical=math.sin(movedir)
		local movedist=vector.distance(a.x,a.y,a.destination.x,a.destination.y)
		if movedist<=a.vel then
			a.destination=nil
		end
--]]
end

return
{
	make = make,
	control = control,
}