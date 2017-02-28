local function make(a,c)
	a.x=love.math.random(320)
	a.y=love.math.random(240)
	a.c=Enums.colours.blue
	a.d=0
	a.vel=0
	a.size=60
	a.flags=flags.set(a.flags,Enums.flags.enemy)
	a.sfx=false
	local l=Game.settings.levelcurrent
	a.enemyspawn=(Game.settings.score-1)%(#l.enemies)+1
end

local function control(a,gs)
	local ea=Enums.actors

	if a.sfx==false then
		if Timer-a.delta>=20 then
			sfx.play(9)
			a.sfx=true
		end
	end

	a.size=a.size-gs
	if a.size<=0 then
		local l=Game.settings.levelcurrent

		actor.make(ea.character,l.enemies[a.enemyspawn],a.x,a.y)
		for i=1,20 do
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