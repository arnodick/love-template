local function make(a,c)
	a.x=love.math.random(320)
	a.y=love.math.random(240)
	a.c=Enums.colours.blue
	a.d=0
	a.vel=0
	a.size=60
	a.flags=flags.set(a.flags,Enums.flags.enemy)
end

local function control(a,gs)
	local ea=Enums.actors
	a.size=a.size-gs
	if a.size<=0 then
		actor.make(ea.character,Game.settings.levelcurrent.enemies[1],a.x,a.y)
		for i=1,20 do
			--actor.make(ea.effect,ea.effects.cloud,a.x,a.y,math.randomfraction(math.pi*2),math.randomfraction(1))

			local spark=actor.make(ea.effect,ea.effects.spark,a.x,a.y)
			spark.c=Enums.colours.dark_blue
		end
		a.delete=true
	end
end

local function draw(a)
	love.graphics.rectangle("line",a.x-a.size/2,a.y-a.size/2,a.size,a.size)
end

return
{
	make = make,
	control = control,
	draw = draw,
}