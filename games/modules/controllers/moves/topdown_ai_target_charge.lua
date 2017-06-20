local function control(a,c)
	if a.destination then
		local movedir=vector.direction(vector.components(a.x,a.y,a.destination.x,a.destination.y))
		c.movehorizontal=math.cos(movedir)
		c.movevertical=math.sin(movedir)
		local movedist=vector.distance(a.x,a.y,a.destination.x,a.destination.y)
		if movedist<=a.vel then
			a.destination=nil
		end
	else
		local dir=vector.direction(vector.components(a.x,a.y,c.target.x,c.target.y))
		local dist=vector.distance(a.x,a.y,c.target.x,c.target.y)*1.5
		a.destination={}
		a.destination.x=math.clamp(a.x+math.cos(dir)*dist,0,Game.width)
		a.destination.y=math.clamp(a.y+math.sin(dir)*dist,0,Game.height)
		sfx.play(12)
	end
end

return
{
	control = control,
}