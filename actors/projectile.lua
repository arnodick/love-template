local function make(a,c,...)
	a.cinit=c or Enums.colours.red
	a.c=a.cinit
	if _G[Enums.actors.projectiles[a.st]]["make"] then
		_G[Enums.actors.projectiles[a.st]]["make"](a,...)
	end
end

local function control(a,gs)
	if _G[Enums.actors.projectiles[a.st]]["control"] then
		_G[Enums.actors.projectiles[a.st]]["control"](a,gs)
	end
end

local function draw(a)
	if _G[Enums.actors.projectiles[a.st]]["draw"] then
		_G[Enums.actors.projectiles[a.st]]["draw"](a)
	end
end

local function predraw(a)
	if _G[Enums.actors.projectiles[a.st]]["predraw"] then
		_G[Enums.actors.projectiles[a.st]]["predraw"](a)
	end
end

local function collision(a)
	if _G[Enums.actors.projectiles[a.st]]["collision"] then
		_G[Enums.actors.projectiles[a.st]]["collision"](a)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
	predraw = predraw,
	collision = collision,
}