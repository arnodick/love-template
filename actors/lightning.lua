local function make(g,a)
	-- a.c=c or EC.blue
	a.c=c or "blue"
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

return
{
	make = make,
	control = control,
}