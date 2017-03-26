local function make(a,c,size,spr,hp,ct)
	local e=Enums
	local ec=Enums.controllers
	a.cinit=c or EC.red
	a.c=a.cinit
	a.size=size or 2
	a.spr=spr or 8
	a.hp=hp or 32
	controller.make(a,ec.target_charge)
	a.hit=0
	a.hitsfx=3
	a.hittime=6
	a.hitcolour=7
	a.target=Player
	a.value=1
	a.speed=1.5
	animation.make(a,6,2)
	hitradius.make(a,8)
	a.flags=flags.set(a.flags,e.flags.enemy)
end

local function control(a)
	if actor.collision(a.x,a.y,a.target) then
		actor.damage(a.target,8)
		actor.damage(a,a.hp)
	end
	if Player.hp<=0 then
		for i,v in ipairs(Game.actors) do
			if flags.get(v.flags,EF.enemy) then
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
	for i=1,3 do
		actor.make(EA.collectible,EA.collectibles.coin,a.x,a.y)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
	dead = dead,
}