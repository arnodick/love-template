local function make(a,c,size)
	sfx.play(1,a.x,a.y)
	a.cinit=c or Enums.colours.white
	a.c=a.cinit
	a.size=size or 20
	a.r=0
	a.flags=actor.setflags(a.flags, Enums.flags.gravity,Enums.flags.ground_delta)
	Camera.shake=a.size
end

local function control(a,gs)
	local delta = (Timer-a.delta)
	a.r = a.size*(delta/6)
	if a.r>=a.size then
		for j=1,6*a.size do
			local s = math.randomfraction(a.size/2)
			local dir = math.randomfraction(math.pi*2)
			local d = math.randomfraction(math.pi*2)
			actor.make(Enums.actors.effect,Enums.effects.cloud,a.x+math.cos(dir)*s,a.y+math.sin(dir)*s,d,math.randomfraction(0.5))
		end
		a.delete=true
	end
end

local function draw(a)
	love.graphics.circle("fill",a.x,a.y,a.r,16)
	if DebugMode then
		love.graphics.setColor(Palette[11])
		love.graphics.circle("line",a.x,a.y,a.r)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
}