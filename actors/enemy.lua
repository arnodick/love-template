local function make(a,spr,size,hp,ct)
	--TODO do these with ini files like Guntypes
	a.spr=spr
	a.size=size
	a.hp=hp
	a.hit=0
	a.hitsfx=5
	a.hittime=6
	a.hitcolour=7
	a.flags = actor.setflags(a.flags, Enums.flags.damageable, Enums.flags.explodable)
	--TODO even enemy should be a flag?
	if ct then--TODO make these flags?
		controller.make(a,ct)
	end
	if _G[Enums.enemynames[a.st]]["make"] then
		_G[Enums.enemynames[a.st]]["make"](a)
	end
end

local function control(a)
	if _G[Enums.enemynames[a.st]]["control"] then
		_G[Enums.enemynames[a.st]]["control"](a)
	end
end

local function draw(a)
	if _G[Enums.enemynames[a.st]]["draw"] then
		_G[Enums.enemynames[a.st]]["draw"](a)
	end
end


local function hitground(a)

end

return
{
	make = make,
	control = control,
	draw = draw,
	hitground = hitground,
}