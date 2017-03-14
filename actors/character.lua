local function make(a,...)
	a.flags = flags.set(a.flags, Enums.flags.damageable, Enums.flags.shootable, Enums.flags.explosive)
	hitbox.make(a,-4,-4,8,8)
	if _G[EA.characters[a.st]]["make"] then
		_G[EA.characters[a.st]]["make"](a,...)
	end
end

local function control(a,gs)
	if _G[EA.characters[a.st]]["control"] then
		_G[EA.characters[a.st]]["control"](a)
	end
end

local function draw(a)
	if _G[EA.characters[a.st]]["draw"] then
		_G[EA.characters[a.st]]["draw"](a)
	end
end

local function collision(a)
	if _G[EA.characters[a.st]]["collision"] then
		_G[EA.characters[a.st]]["collision"](a)
	end
end

local function damage(a)
	if _G[EA.characters[a.st]]["damage"] then
		_G[EA.characters[a.st]]["damage"](a)
	end
end

local function dead(a)
	actor.corpse(a,Game.tile.width,Game.tile.height)

	if _G[EA.characters[a.st]]["dead"] then
		_G[EA.characters[a.st]]["dead"](a)
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