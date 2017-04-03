local function make(t)
	local s={}--TODO change this to another letter
	s.t=t
	if _G[Enums.states[s.t]]["make"] then
		_G[Enums.states[s.t]]["make"](s)
	end
	return s
end

local function control(g,s)
	if _G[Enums.states[s.t]]["control"] then
		_G[Enums.states[s.t]]["control"](g,s)
	end
end

local function keypressed(g,s,key)
	if _G[Enums.states[s.t]]["keypressed"] then
		_G[Enums.states[s.t]]["keypressed"](g,s,key)
	end
end

local function gamepadpressed(g,s,button)
	if _G[Enums.states[s.t]]["gamepadpressed"] then
		_G[Enums.states[s.t]]["gamepadpressed"](g,s,button)
	end
end

local function draw(g,s)
	if _G[Enums.states[s.t]]["draw"] then
		_G[Enums.states[s.t]]["draw"](g,s)
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