local function make(a,c)
	a.c=c or EC.red
	a.d=0
	a.vel=1
end

local function draw(a)
	LG.line(a.x,0,a.x,Game.height)
	LG.setCanvas(Canvas.buffer)
		LG.setColor(Palette[EC.black])
		LG.line(a.x,0,a.x,Game.height)
	LG.setCanvas(Canvas.game)
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