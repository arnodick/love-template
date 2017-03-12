local function make(a,...)
	a.flags = flags.set(a.flags, Enums.flags.damageable, Enums.flags.shootable, Enums.flags.explosive)
	hitbox.make(a,-4,-4,8,8)
	if _G[Enums.actors.characters[a.st]]["make"] then
		_G[Enums.actors.characters[a.st]]["make"](a,...)
	end
end

local function control(a,gs)
	if a.tail then
		local c=a.controller
		tail.control(a.tail,gs,a,c.aimhorizontal,c.aimvertical)
	end
	if _G[Enums.actors.characters[a.st]]["control"] then
		_G[Enums.actors.characters[a.st]]["control"](a)
	end
end

local function draw(a)
	if a.tail then
		tail.draw(a.tail)
	end
	if _G[Enums.actors.characters[a.st]]["draw"] then
		_G[Enums.actors.characters[a.st]]["draw"](a)
	end
end

local function collision(a)
	if _G[Enums.actors.characters[a.st]]["collision"] then
		_G[Enums.actors.characters[a.st]]["collision"](a)
	end
end

local function damage(a)
	if _G[Enums.actors.characters[a.st]]["damage"] then
		_G[Enums.actors.characters[a.st]]["damage"](a)
	end
end

local function dead(a)
	actor.corpse(a,Game.tile.width,Game.tile.height)

	if _G[Enums.actors.characters[a.st]]["dead"] then
		_G[Enums.actors.characters[a.st]]["dead"](a)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
	collision = collision,
	damage = damage,
	dead = dead,
}