local function make(a)
	a.spr=65
	a.size=1
	a.angle=-a.d
end

local function control(a)
	for i,enemy in ipairs(Actors) do
		if actor.getflag(enemy.flags,Enums.flags.shootable) then
			if not enemy.delete then
				if actor.collision(a.x,a.y,enemy) then
					a.delete=true
					actor.damage(enemy,Bullettypes[a.st].dam)
				end
			end
		end
	end
end

local function draw(a)
	
end


return
{
	make = make,
	control = control,
	draw = draw,
}