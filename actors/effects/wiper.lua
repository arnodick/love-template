local function make(a,c)
	a.c=c or Enums.colours.red
	a.d=0
	a.vel=1
end

local function draw(a)
	love.graphics.line(a.x,0,a.x,Game.height)
	love.graphics.setCanvas(Canvas.buffer)
		love.graphics.setColor(Palette[Enums.colours.black])
		love.graphics.line(a.x,0,a.x,Game.height)
	love.graphics.setCanvas(Canvas.game)
end

local function collision(a)
	a.delete=true
end

return
{
	make = make,
	draw = draw,
	collision = collision,
}