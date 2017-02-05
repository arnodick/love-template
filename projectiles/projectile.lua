local function make(a)
	a.tail={a.x,a.y}
	if _G[Enums.projectilenames[a.st]]["make"] then
		_G[Enums.projectilenames[a.st]]["make"](a)
	end
end

local function control(a,gs)
	if _G[Enums.projectilenames[a.st]]["control"] then
		_G[Enums.projectilenames[a.st]]["control"](a,gs)
	end
end

local function hitground(a)
	if _G[Enums.projectilenames[a.st]]["hitground"] then
		_G[Enums.projectilenames[a.st]]["hitground"](a)
	end
end

local function draw(a)
	if _G[Enums.projectilenames[a.st]]["draw"] then
		_G[Enums.projectilenames[a.st]]["draw"](a)
	end
end

return
{
	make = make,
	control = control,
	hitground = hitground,
	draw = draw,
}