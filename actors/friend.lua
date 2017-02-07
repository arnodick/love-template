local function make(a,spr,size,hp,ct)
	a.spr=spr
	a.size=size
	a.hp=hp
	if ct then
		controller.make(a,ct)
	end
	if _G[Enums.friendnames[a.st]]["make"] then
		_G[Enums.friendnames[a.st]]["make"](a)
	end
end

local function control(a)
	local e=Enums
	Game.speed=(a.controller[e.lefttrigger]+1)/2
	a.d=vector.direction(a.controller[e.leftstickhorizontal],a.controller[e.leftstickvertical])
	a.vel=vector.length(a.controller[e.leftstickhorizontal],a.controller[e.leftstickvertical])
	if _G[Enums.friendnames[a.st]]["control"] then
		_G[Enums.friendnames[a.st]]["control"](a)
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