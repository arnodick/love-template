local function make(a)
	
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
		--love.graphics.setColor(Palette[Enums.colours.green])
		--love.graphics.draw(Spritesheet[a.size],Quads[a.size][a.spr],a.x,a.y,a.angle,1.2,1.2,(a.size*Game.tile.width)/2,(a.size*Game.tile.height)/2)
end

local function collision(a)

end

return
{
	make = make,
	control = control,
	draw = draw,
	collision = collision,
}