local function make(a,c,size)
	a.cinit=c or EC.indigo
	a.c=a.cinit
	a.size=size or 6
	a.angle=-a.d
	a.anglespeed=0.02
	a.pointdirs={}
	for i=0,3 do
		table.insert(a.pointdirs, math.randomfraction(math.pi/2) + (math.pi/2)*i )
	end
	a.r=size
	a.flags=flags.set(a.flags,EF.bouncy)
end

local function control(a)
	local delta=Game.timer-a.delta
	a.r=a.size-delta/5
	if a.r<1 then
		a.delete=true
	end
end

local function draw(a)
	local points={}
	for i=1,#a.pointdirs do
		table.insert(points,a.x+math.cos(a.pointdirs[i]+a.angle)*a.r)
		table.insert(points,a.y+math.sin(a.pointdirs[i]+a.angle)*a.r/2.5)
	end
	LG.polygon("fill",points)
	if Debugger.debugging then
		LG.setColor(Game.palette[EC.green])
		LG.points(a.x,a.y)
		LG.setColor(Game.palette[EC.red])
		for i=1,#points,2 do
			LG.points(points[i],points[i+1])
		end
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
}