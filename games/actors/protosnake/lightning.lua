local function make(g,a)
	a.c=c or EC.blue
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

local function draw(a)
		--LG.setColor(Game.palette[EC.green])
		--LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],a.x,a.y,a.angle,1.2,1.2,(a.size*Game.tile.width)/2,(a.size*Game.tile.height)/2)
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