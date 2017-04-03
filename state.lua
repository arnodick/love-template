local function make(t)
	local m={}--TODO change this to another letter
	m.t=t
	if _G[Enums.states[m.t]]["make"] then
		_G[Enums.states[m.t]]["make"](m)
	end
	return m
end

local function control(m)
	if _G[Enums.states[m.t]]["control"] then
		_G[Enums.states[m.t]]["control"](m)
	end
end

local function keypressed(m,key)
	if _G[Enums.states[m.t]]["keypressed"] then
		_G[Enums.states[m.t]]["keypressed"](m,key)
	end
end

local function gamepadpressed(m,button)
	if _G[Enums.states[m.t]]["gamepadpressed"] then
		_G[Enums.states[m.t]]["gamepadpressed"](m,button)
	end
end

local function draw(g,m)
	if _G[Enums.states[m.t]]["draw"] then
		_G[Enums.states[m.t]]["draw"](g,m)
	end
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}