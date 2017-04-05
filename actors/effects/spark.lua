local function make(a,c)
	a.c=c or EC.yellow
	a.d=math.randomfraction(math.pi*2)
	a.vel=math.randomfraction(2)+2
	a.decel=0.1
	a.flags=flags.set(a.flags,EF.bouncy)
end

local function control(a)
	if a.vel<=0 then
		a.delete=true
	end
end

local function draw(a)
	LG.points(a.x,a.y)
	if a.vel<=0 then
		LG.setCanvas(Game.canvas.static)
			LG.points(a.x,a.y)
		LG.setCanvas(Game.canvas.main)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
}