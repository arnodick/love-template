local function make(a)
	a.c=Enums.colours.orange
	a.d=math.randomfraction(math.pi*2)
	a.vel=love.math.random(3,4)
	a.decel=0.05
end

local function control(a)
	if a.vel<1 then
		a.delete=true
	end
end

local function draw(a)
	love.graphics.points(a.x,a.y)
end

return
{
	make = make,
	control = control,
	draw = draw,
}