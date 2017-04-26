local function make(a)
	a.spr=65
	a.size=1
	a.angle=-a.d
end

local function control(a)
	local dam=1
	for i,enemy in ipairs(Game.actors) do
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

local function draw(a)
		--LG.setColor(Game.palette[EC.green])
		--LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],a.x,a.y,a.angle,1.2,1.2,(a.size*Game.tile.width)/2,(a.size*Game.tile.height)/2)
end

local function predraw(a)
		--LG.setColor(Game.palette[EC.dark_green])
		--LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],a.x,a.y,a.angle,1.8,1.8,(a.size*Game.tile.width)/2,(a.size*Game.tile.height)/2)
end

local function collision(a)
	a.delete=true
end

return
{
	make = make,
	control = control,
	draw = draw,
	predraw = predraw,
	collision = collision,
}