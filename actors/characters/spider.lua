local function make(a,c,size,spr,hp,ct)
	local e=Enums
	local ec=Enums.controllers
	a.cinit=c or e.colours.red
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 49
	a.hp=hp or 32
	controller.make(a,ec.target_charge)
	a.hit=0
	a.hitsfx=3
	a.hittime=6
	a.hitcolour=7
	a.target=Player
	a.value=1
	a.speed=1.5
	animation.make(a,10,2)
	a.flags=flags.set(a.flags,e.flags.enemy)
end

local function control(a)
	if actor.collision(a.x,a.y,a.target) then
		actor.damage(a.target,3)
		actor.damage(a,a.hp)
	end
	if Player.hp<=0 then
		for i,v in ipairs(Actors) do
			if flags.get(v.flags,Enums.flags.enemy) then
				if v~=a then
					a.target=v
				end
			end
		end
	end
end


local function draw(a)

end

local function dead(a)
	local ea=Enums.actors
	for i=1,3 do
		actor.make(ea.collectible,ea.collectibles.coin,a.x,a.y)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
	dead = dead,
}