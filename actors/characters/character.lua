local function make(a,...)
	a.flags = flags.set(a.flags, Enums.flags.damageable, Enums.flags.shootable, Enums.flags.explosive)
	hitbox.make(a,-4,-4,8,8)
	if _G[Enums.characternames[a.st]]["make"] then
		_G[Enums.characternames[a.st]]["make"](a,...)
	end
end

local function control(a)
	if _G[Enums.characternames[a.st]]["control"] then
		_G[Enums.characternames[a.st]]["control"](a)
	end
end

local function draw(a)
	if _G[Enums.characternames[a.st]]["draw"] then
		_G[Enums.characternames[a.st]]["draw"](a)
	end
end

local function collision(a)
	if _G[Enums.characternames[a.st]]["collision"] then
		_G[Enums.characternames[a.st]]["collision"](a)
	end
end

local function damage(a)
	if _G[Enums.characternames[a.st]]["damage"] then
		_G[Enums.characternames[a.st]]["damage"](a)
	end
end

local function dead(a)
	if _G[Enums.characternames[a.st]]["dead"] then
		_G[Enums.characternames[a.st]]["dead"](a)
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