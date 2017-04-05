local function make(g,t)
	g.state={}
	g.state.t=t
	if _G[Enums.states[g.state.t]]["make"] then
		_G[Enums.states[g.state.t]]["make"](g)
	end
	return s
end

local function control(g)
	local s=g.state
	if _G[Enums.states[s.t]]["control"] then
		_G[Enums.states[s.t]]["control"](g)
	end
end

local function change(g,s)
	local e=Enums
	--initializes game's state, timer, camera, actor, menu and state tables
	state.make(g,s)
	g.timer=0
	g.speed=1
	g.camera=camera.make(0,0)
	g.actors={}
	g.menus={}
	g.counters=counters.init()

	if _G[Enums.states[s]]["change"] then
		_G[Enums.states[s]]["change"](g,s)
	end
end

local function keypressed(g,key)
	local s=g.state
	if _G[Enums.states[s.t]]["keypressed"] then
		_G[Enums.states[s.t]]["keypressed"](g,key)
	end
end

local function gamepadpressed(g,button)
	local s=g.state
	if _G[Enums.states[s.t]]["gamepadpressed"] then
		_G[Enums.states[s.t]]["gamepadpressed"](g,button)
	end
end

local function draw(g)
	local s=g.state
	if _G[Enums.states[s.t]]["draw"] then
		_G[Enums.states[s.t]]["draw"](g)
	end
end

return
{
	make = make,
	control = control,
	change = change,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}