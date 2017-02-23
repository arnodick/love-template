local function make(a,...)
	if _G[Enums.actors.effects[a.st]]["make"] then
		_G[Enums.actors.effects[a.st]]["make"](a,...)
	end
end

local function control(a)
	if _G[Enums.actors.effects[a.st]]["control"] then
		_G[Enums.actors.effects[a.st]]["control"](a)
	end
end

local function draw(a)
	if _G[Enums.actors.effects[a.st]]["draw"] then
		_G[Enums.actors.effects[a.st]]["draw"](a)
	end
end

local function collision(a)
	if _G[Enums.actors.effects[a.st]]["collision"] then
		_G[Enums.actors.effects[a.st]]["collision"](a)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
	collision = collision,
}