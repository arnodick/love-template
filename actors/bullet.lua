local bullet={}

bullet.make = function(g,a,c)
	a.cinit=c or "green"
	a.c=a.cinit
	a.spr=65
	a.size=1
	a.angle=-a.d
	--a.draw=false
end

bullet.control = function(g,a)
	local dam=1
	for i,enemy in ipairs(g.actors) do
		if flags.get(enemy.flags,EF.shootable) then
			if not enemy.delete then
				if actor.collision(a.x,a.y,enemy) then
					a.delete=true
					actor.damage(g,enemy,dam)
				end
			end
		end
	end
end

bullet.collision = function(g,a)
	a.delete=true
end

return bullet