local function make(a,c)
	a.c=c or Enums.colours.orange
	a.d=math.randomfraction(math.pi*2)
	a.vel=math.randomfraction(2)+2
	a.decel=0.05
	a.flags=flags.set(a.flags,Enums.flags.bouncy)
end

local function control(a)
	if a.vel<=0 then
		a.delete=true
	end
end

local function draw(a)
	love.graphics.points(a.x,a.y)
	if a.vel<=0 then
		love.graphics.setCanvas(Canvas.buffer)
			love.graphics.points(a.x,a.y)
		love.graphics.setCanvas(Canvas.game)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
}