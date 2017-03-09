local function make(a,c,size,spr,hp,ct)
	local e=Enums
	local ec=Enums.controllers
	a.cinit=c or e.colours.yellow
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 97
	a.hp=hp or 16
	controller.make(a,ec.target_seek)
	a.hit=0
	a.hitsfx=3
	a.hittime=6
	a.hitcolour=7
	a.target={}
	a.target.x=Game.width/2
	a.target.y=Game.height/3
	a.speed=2

	animation.make(a,10,2)
	a.flags=flags.set(a.flags,e.flags.enemy)
end

local function control(a)
	local dist=vector.distance(a.x,a.y,Player.x,Player.y)
	local c=Enums.colours

	if dist<30 then
		if not a.menu then
			a.menu=menu.make(a.x,a.y-38,50,50,{"what you buy do you want to buy the powerup ?"},c.orange,c.dark_green,c.indigo,c.dark_purple)
		end
	elseif a.menu then
		a.menu=nil
	end
end

local function draw(a)
	if a.menu then
		menu.draw(a.menu)
	end
end

local function dead(a)
	local ea=Enums.actors
	local port=actor.make(ea.effect,ea.effects.portal,math.floor(a.x),math.floor(a.y))
	port.level=Levels.store
end

return
{
	make = make,
	control = control,
	draw = draw,
	dead = dead,
}