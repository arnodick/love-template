local function make(a)
	a.size=1
	a.sprinit=145
	a.spr=a.sprinit
	a.rof=4
	a.snd=2
	a.spd=2

	a.cost=3
	hitbox.make(a,-4,-4,8,8)
end

local function control(a)
	local ea=Enums.actors
	if not flags.get(a.flags,Enums.flags.shopitem) then
		if not a.spr then
			a.spr=a.sprinit
		end
	end
	for i,v in pairs(Actors) do
		if v.t==Enums.actors.projectile then
			if actor.collision(v.x,v.y,a) then
			for i=1,20 do
				local spark=actor.make(ea.effect,ea.effects.spark,v.x,v.y)
					spark.c=v.cinit
   				end
				v.delete=true
			end
		end
	end
end

local function draw(a)
	
end

local function shoot(a)
	
end

return
{
	make = make,
	control = control,
	draw = draw,
	shoot = shoot,
}