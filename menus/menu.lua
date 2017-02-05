local function make(t)
	local m={}
	m.t=t
	if _G[Enums.statenames[m.t]]["make"] then
		_G[Enums.statenames[m.t]]["make"](m)
	end
	table.insert(Menus,m)
	return m
end

local function control(m)
	if _G[Enums.statenames[m.t]]["control"] then
		_G[Enums.statenames[m.t]]["control"](m)
	end
end

local function keypressed(m,key)
	if _G[Enums.statenames[m.t]]["keypressed"] then
		_G[Enums.statenames[m.t]]["keypressed"](m,key)
	end
end

local function draw(m)
	if _G[Enums.statenames[m.t]]["draw"] then
		_G[Enums.statenames[m.t]]["draw"](m)
	end
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	draw = draw,
}