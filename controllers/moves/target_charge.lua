local function control(a,c)
	if a.movetarget then
		local movedir=vector.direction(vector.components(a.x,a.y,a.movetarget.x,a.movetarget.y))
		c.movehorizontal=math.cos(movedir)
		c.movevertical=math.sin(movedir)
		local movedist=vector.distance(a.x,a.y,a.movetarget.x,a.movetarget.y)
		if movedist<=a.vel then
			a.movetarget=nil
		end
	else
		local dir=vector.direction(vector.components(a.x,a.y,a.target.move.x,a.target.move.y))
		local dist=vector.distance(a.x,a.y,a.target.move.x,a.target.move.y)*1.5
		a.movetarget={}
		a.movetarget.x=math.clamp(a.x+math.cos(dir)*dist,0,Game.width)
		a.movetarget.y=math.clamp(a.y+math.sin(dir)*dist,0,Game.height)
		sfx.play(12)
	end
	a.d=vector.direction(c.movehorizontal,-c.movevertical)
	a.vel=vector.length(c.movehorizontal,c.movevertical)*a.speed--TODO put speed in main actor stuff
end

return
{
	control = control,
}