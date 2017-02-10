local function make(a,spr,size,hp,ct)
	a.spr=spr or 1
	a.size=size or 1
	a.hp=hp or 1
	if ct then
		controller.make(a,ct)
	end
	a.flags = actor.setflags(a.flags, Enums.flags.damageable, Enums.flags.explodable, Enums.flags.shootable, Enums.flags.explosive)
	hitbox.make(a,-4,-4,8,8)
	if _G[Enums.characternames[a.st]]["make"] then
		_G[Enums.characternames[a.st]]["make"](a)
	end
end

local function control(a)
	if _G[Enums.characternames[a.st]]["control"] then
		_G[Enums.characternames[a.st]]["control"](a)
	end
end

local function hitground(a)

end

local function draw(a)
	--love.graphics.points(a.x,a.y)
end

return
{
	make = make,
	control = control,
	hitground = hitground,
	draw = draw,
}