local function control(a,c)
	local maxdist=100

	local dir=vector.direction(vector.components(a.x,a.y,c.target.x,c.target.y))
	local dist=vector.distance(a.x,a.y,c.target.x,c.target.y)
--move to point
	if a.destination then
		local movedir=vector.direction(vector.components(a.x,a.y,a.destination.x,a.destination.y))
		c.movehorizontal=math.cos(movedir)
		c.movevertical=math.sin(movedir)
		local movedist=vector.distance(a.x,a.y,a.destination.x,a.destination.y)
		if movedist<=a.vel then
			a.destination=nil
		end
--avoid
	elseif dist<maxdist then
		if a.x>Game.width-32 or a.x<32 or a.y>Game.height-32 or a.y<32 then
			a.destination={}
			a.destination.x,a.destination.y=love.math.random(Game.width),love.math.random(Game.height)
			local movedist=vector.distance(a.destination.x,a.destination.y,c.target.x,c.target.y)
			while movedist<maxdist do
				a.destination.x,a.destination.y=love.math.random(Game.width),love.math.random(Game.height)
				movedist=vector.distance(a.destination.x,a.destination.y,c.target.x,c.target.y)
			end
			dir=vector.direction(vector.components(a.x,a.y,a.destination.x,a.destination.y))
			c.movehorizontal=math.cos(dir)
			c.movevertical=math.sin(dir)
		else
			a.destination=nil
			c.movehorizontal=-math.cos(dir)
			c.movevertical=-math.sin(dir)
		end
--random jitter
	else
		a.destination=nil
		local x,y=love.math.random(Game.width),love.math.random(Game.height)
		local movedist=vector.distance(x,y,c.target.x,c.target.y)
		while movedist<maxdist do
			x,y=love.math.random(Game.width),love.math.random(Game.height)
			movedist=vector.distance(x,y,c.target.x,c.target.y)
		end
		local movedir=vector.direction(vector.components(a.x,a.y,x,y))
		c.movehorizontal=math.cos(movedir)
		c.movevertical=math.sin(movedir)
	end
end

return
{
	control = control,
}