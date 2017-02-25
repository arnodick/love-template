local function make(a,c,size,spr,hp,ct)
	local e=Enums
	local ec=Enums.controllers
	a.cinit=c or e.colours.dark_green
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 49
	a.hp=hp or 8
	controller.make(a,ec.shoot_accurate)
	a.hit=0
	a.hitsfx=3
	a.hittime=6
	a.hitcolour=7
	a.target=Player
	gun.make(a,Enums.guns.machinegun,9,-math.pi,0,Enums.colours.green)
	animation.make(a,10,2)
	a.flags=flags.set(a.flags,e.flags.bouncy,e.flags.enemy)
	a.d=math.choose(math.pi)
	a.vel=1
end

local function control(a)
	if Player.hp<=0 then
		for i,v in ipairs(Actors) do
			if v.t==Enums.actors.character then
				a.target=v
			end
		end
	end
end

local function hitground(a)

end

local function draw(a)

end

local function dead(a)
	local ea=Enums.actors
	actor.make(ea.item,ea.items.coin,a.x,a.y)
end

return
{
	make = make,
	control = control,
	hitground = hitground,
	draw = draw,
	dead = dead,
}