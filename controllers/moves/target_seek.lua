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

--[[
		local movedir=vector.direction(vector.components(a.x,a.y,a.movetarget.x,a.movetarget.y))
		c.movehorizontal=math.cos(movedir)
		c.movevertical=math.sin(movedir)
		local movedist=vector.distance(a.x,a.y,a.movetarget.x,a.movetarget.y)
		if movedist<=a.vel then
			a.movetarget=nil
		end
--]]
end

return
{
	control = control,
}