local function make(a)
	a.spr=65
	a.size=1
	a.angle=-a.d
end

local function control(a)
	local dam=1
	for i,enemy in ipairs(Actors) do
		if flags.get(enemy.flags,Enums.flags.shootable) then
			if not enemy.delete then
				if actor.collision(a.x,a.y,enemy) then
					a.delete=true
					actor.damage(enemy,dam)
				end
			end
		end
	end
end

local function draw(a)
	
end

local function collision(a)
	a.delete=true
end

return
{
	make = make,
	control = control,
	draw = draw,
	collision = collision,
}