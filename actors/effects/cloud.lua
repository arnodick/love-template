local function make(a,c,size)
	a.cinit=c or Enums.colours.indigo
	a.c=a.cinit
	a.size=size or 6
	a.angle=-a.d
	a.anglespeed=0.02
	a.pointdirs={}
	for i=0,3 do
		table.insert(a.pointdirs, math.randomfraction(math.pi/2) + (math.pi/2)*i )
	end
	a.r=size
	a.flags = flags.set(a.flags, Enums.flags.gravity,Enums.flags.ground_delta,Enums.flags.bouncy)
end

local function control(a)
	local delta=Timer-a.delta
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
	love.graphics.polygon("fill",points)
	if DebugMode then
		love.graphics.setColor(Palette[Enums.colours.green])
		love.graphics.points(a.x,a.y)
		love.graphics.setColor(Palette[Enums.colours.red])
		for i=1,#points,2 do
			love.graphics.points(points[i],points[i+1])
		end
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
}