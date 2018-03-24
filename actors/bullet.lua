local function make(g,a,c)
	a.cinit=c or EC.red
	a.c=a.cinit
	a.spr=65
	a.size=1
	a.angle=-a.d
end

local function control(g,a)
	local dam=1
	for i,enemy in ipairs(g.actors) do
		if flags.get(enemy.flags,EF.shootable) then
			if not enemy.delete then
				if actor.collision(a.x,a.y,enemy) then
					a.delete=true
					actor.damage(enemy,dam)
				end
			end
		end
	end
end

local function collision(a)
	a.delete=true
end

return
{
	make = make,
	control = control,
	collision = collision,
}