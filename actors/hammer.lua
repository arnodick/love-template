local function make(a,c)
	a.c=c or EC.dark_purple
	a.size=1
	a.sprinit=145
	a.spr=a.sprinit
	a.rof=4
	a.snd=2
	a.spd=2

	a.cost=3
	module.make(a,EA.modules.hitradius,4)
end

local function control(a)
	if not flags.get(a.flags,EF.shopitem) then
		if not a.spr then
			a.spr=a.sprinit
		end
	end
	for i,v in pairs(Game.actors) do
		if v.t==EA.projectile then
			if actor.collision(v.x,v.y,a) then
			for i=1,20 do
				local spark=actor.make(EA.spark,v.x,v.y)
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