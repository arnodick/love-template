local function control(a)
	local e=Enums.commands
	local c=a.controller

	local dir=vector.direction(vector.components(a.x,a.y,a.target.x,a.target.y))
	local dist=vector.distance(a.x,a.y,a.target.x,a.target.y)
	if dist<150 then
		c.movehorizontal=-math.cos(dir)
		c.movevertical=-math.sin(dir)
	else
		local x,y=love.math.random(Game.width),love.math.random(Game.height)
		local movedist=vector.distance(x,y,a.target.x,a.target.y)
		while movedist<150 do
			x,y=love.math.random(Game.width),love.math.random(Game.height)
			movedist=vector.distance(x,y,a.target.x,a.target.y)
		end
		local movedir=vector.direction(vector.components(a.x,a.y,x,y))
		c.movehorizontal=math.cos(movedir)
		c.movevertical=math.sin(movedir)
	end
	a.d=vector.direction(c.movehorizontal,-c.movevertical)
	a.vel=vector.length(c.movehorizontal,c.movevertical)
end

return
{
	control = control,
}