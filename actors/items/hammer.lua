local function make(g)
	g.size=1
	g.sprinit=145
	g.spr=g.sprinit
	g.rof=4
	g.snd=2
	g.spd=2

	g.cost=3
	hitbox.make(g,-4,-4,8,8)
end

local function control(g)
	local ea=Enums.actors
	if not flags.get(g.flags,Enums.flags.shopitem) then
		if not g.spr then
			g.spr=g.sprinit
		end
	end
	for i,v in pairs(Actors) do
		if v.t==Enums.actors.projectile then
			if actor.collision(v.x,v.y,g) then
		for i=1,20 do
				local spark=actor.make(ea.effect,ea.effects.spark,v.x,v.y)
					spark.c=v.cinit
   				end
				v.delete=true
			end
		end
	end
end

local function draw(g)
	
end

local function shoot(g)
	
end

return
{
	make = make,
	control = control,
	draw = draw,
	shoot = shoot,
}