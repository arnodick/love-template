local function make(g,a,c)
	a.c=c or EC.red
	a.d=0
	a.vel=1
end

local function draw(g,a)
	LG.line(a.x,0,a.x,g.level.map.height)
	LG.setCanvas(g.level.canvas.background)
		LG.setColor(g.palette[EC.black])
		LG.line(a.x,0,a.x,g.level.map.height)
	LG.setCanvas(g.canvas.main)
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