local function make(a)
	local e=Enums.buttons
	local c=a.controller
	c[e.leftstickhorizontal]=math.choose(-1,1)
end

local function control(a)
	local e=Enums.buttons
	local c=a.controller

	local dir=vector.direction(vector.components(a.x,a.y,Player.x,Player.y))
	c[e.rightstickhorizontal]=math.cos(dir)
	c[e.rightstickvertical]=math.sin(dir)

	if a.x<=0 then
		c[e.leftstickhorizontal]=1
	elseif a.x>=320 then
		c[e.leftstickhorizontal]=-1
	end
	if love.math.random(20)==1 then
		c[e.button1]=true
	else
		c[e.button1]=false
	end
end

return
{
	make = make,
	control = control,
}