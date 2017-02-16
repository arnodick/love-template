local function make(a,...)
	if _G[Enums.effectnames[a.st]]["make"] then
		_G[Enums.effectnames[a.st]]["make"](a,...)
	end
end

local function control(a)
	if _G[Enums.effectnames[a.st]]["control"] then
		_G[Enums.effectnames[a.st]]["control"](a)
	end
end

local function draw(a)
	if _G[Enums.effectnames[a.st]]["draw"] then
		_G[Enums.effectnames[a.st]]["draw"](a)
	end
end

local function collision(a,collx,colly)
	if _G[Enums.effectnames[a.st]]["collision"] then
		_G[Enums.effectnames[a.st]]["collision"](a,collx,colly)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
	collision = collision,
}