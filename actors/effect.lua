local function make(a,...)
	a.flags=flags.set(a.flags,Enums.flags.persistent)
	if _G[Enums.actors.effects[a.st]]["make"] then
		_G[Enums.actors.effects[a.st]]["make"](a,...)
	end
end

local function control(a,gs)
	--TODO maybe put timer delete stuff here? all effects go away on their own eventually (or should)
	if _G[Enums.actors.effects[a.st]]["control"] then
		_G[Enums.actors.effects[a.st]]["control"](a,gs)
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