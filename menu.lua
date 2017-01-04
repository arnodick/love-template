local function make(t)
	local m={}
	m.t=t
	_G[Enums.statenames[m.t]]["make"](m)
	table.insert(Menus,m)
	return m
end

local function control(m)
	_G[Enums.statenames[m.t]]["control"](m)
end

local function keypressed(m,key)
	if _G[Enums.statenames[m.t]]["keypressed"] then
		_G[Enums.statenames[m.t]]["keypressed"](m,key)
	end
end

local function draw(m)
	_G[Enums.statenames[m.t]]["draw"](m)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	draw = draw,
}