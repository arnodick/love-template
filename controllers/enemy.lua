local function make(a)
	local e=Enums.commands
	local c=a.controller
	c[e.movehorizontal]=math.choose(-1,1)
end

local function control(a)
	local e=Enums.commands
	local c=a.controller

	local dir=vector.direction(vector.components(a.x,a.y,Player.x,Player.y))
	c[e.aimhorizontal]=math.cos(dir)
	c[e.aimvertical]=math.sin(dir)

	if a.x<=0 then
		c[e.movehorizontal]=1
	elseif a.x>=320 then
		c[e.movehorizontal]=-1
	end
	if love.math.random(20)==1 then
		c[e.shoot]=true
	else
		c[e.shoot]=false
	end
end

return
{
	make = make,
	control = control,
}