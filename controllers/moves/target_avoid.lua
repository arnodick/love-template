local function control(a,c)
	local maxdist=100

	local dir=vector.direction(vector.components(a.x,a.y,a.target.x,a.target.y))
	local dist=vector.distance(a.x,a.y,a.target.x,a.target.y)
--move to point
	if a.movetarget then
		local movedir=vector.direction(vector.components(a.x,a.y,a.movetarget.x,a.movetarget.y))
		c.movehorizontal=math.cos(movedir)
		c.movevertical=math.sin(movedir)
		local movedist=vector.distance(a.x,a.y,a.movetarget.x,a.movetarget.y)
		if movedist<=a.vel then
			a.movetarget=nil
		end
--avoid
	elseif dist<maxdist then
		if a.x>Game.width-32 or a.x<32 or a.y>Game.height-32 or a.y<32 then
			a.movetarget={}
			a.movetarget.x,a.movetarget.y=love.math.random(Game.width),love.math.random(Game.height)
			local movedist=vector.distance(a.movetarget.x,a.movetarget.y,a.target.x,a.target.y)
			while movedist<maxdist do
				a.movetarget.x,a.movetarget.y=love.math.random(Game.width),love.math.random(Game.height)
				movedist=vector.distance(a.movetarget.x,a.movetarget.y,a.target.x,a.target.y)
			end
			dir=vector.direction(vector.components(a.x,a.y,a.movetarget.x,a.movetarget.y))
			c.movehorizontal=math.cos(dir)
			c.movevertical=math.sin(dir)
		else
			a.movetarget=nil
			c.movehorizontal=-math.cos(dir)
			c.movevertical=-math.sin(dir)
		end
--random jitter
	else
		a.movetarget=nil
		local x,y=love.math.random(Game.width),love.math.random(Game.height)
		local movedist=vector.distance(x,y,a.target.x,a.target.y)
		while movedist<maxdist do
			x,y=love.math.random(Game.width),love.math.random(Game.height)
			movedist=vector.distance(x,y,a.target.x,a.target.y)
		end
		local movedir=vector.direction(vector.components(a.x,a.y,x,y))
		c.movehorizontal=math.cos(movedir)
		c.movevertical=math.sin(movedir)
	end
	a.d=vector.direction(c.movehorizontal,-c.movevertical)
	a.vel=vector.length(c.movehorizontal,c.movevertical)*a.speed
end

return
{
	control = control,
}