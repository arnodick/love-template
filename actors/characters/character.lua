local function make(a,...)
	a.flags = actor.setflags(a.flags, Enums.flags.damageable, Enums.flags.shootable, Enums.flags.explosive)
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
	damage = damage,
	dead = dead,
}