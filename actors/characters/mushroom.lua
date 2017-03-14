local function make(a,c,size,spr,hp,ct)
	local e=Enums
	local ec=Enums.controllers
	a.cinit=c or EC.yellow
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 97
	a.hp=hp or 16
	controller.make(a,ec.target_avoid)
	a.hit=0
	a.hitsfx=3
	a.hittime=6
	a.hitcolour=7
	a.target=Player
	a.value=1
	a.speed=2
	animation.make(a,10,2)
	a.flags=flags.set(a.flags,e.flags.enemy)

	Game.settings.levelcurrent.enemies.max=Game.settings.levelcurrent.enemies.max+1
end

local function control(a)
	
end

local function dead(a)
	local port=actor.make(EA.effect,EA.effects.portal,math.floor(a.x),math.floor(a.y))
	port.level=Levels.store
end

return
{
	make = make,
	control = control,
	dead = dead,
}