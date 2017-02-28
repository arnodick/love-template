local function make(a,c,size,spr,hp,ct)
	local e=Enums
	local ec=Enums.controllers
	a.cinit=c or e.colours.dark_green
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 97
	a.hp=hp or 8
	--controller.make(a,ec.target_avoid,ec.shoot_lead)
	--controller.make(a,ec.target_avoid)
	a.hit=0
	a.hitsfx=3
	a.hittime=6
	a.hitcolour=7
	a.target=Player
	gun.make(a,Enums.guns.lazer,9,-math.pi,0,Enums.colours.green)
	animation.make(a,10,2)
	a.flags=flags.set(a.flags,e.flags.enemy)
end

local function control(a)
	
end

local function dead(a)
	local ea=Enums.actors
	local port=actor.make(ea.effect,ea.effects.portal,a.x,a.y)
	port.level=Levels.store
end

return
{
	make = make,
	control = control,
	dead = dead,
}