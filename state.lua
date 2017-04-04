local function make(g,t)
	g.states={}
	g.states.t=t
	if _G[Enums.states[g.states.t]]["make"] then
		_G[Enums.states[g.states.t]]["make"](g)
	end
	return s
end

local function control(g)
	local s=g.states
	if _G[Enums.states[s.t]]["control"] then
		_G[Enums.states[s.t]]["control"](g)
	end
end

local function change(g,s)
	local e=Enums
	--initializes game's state, timer, camera, actor, menu and state tables
	g.state=s
	g.timer=0
	g.speed=1
	g.camera=camera.make(0,0)
	g.actors={}
	g.menus={}
	state.make(g,s)
	g.counters=counters.init()

	if _G[Enums.states[s]]["change"] then
		_G[Enums.states[s]]["change"](g,s)
	end
end

local function keypressed(g,key)
	local s=g.states
	if _G[Enums.states[s.t]]["keypressed"] then
		_G[Enums.states[s.t]]["keypressed"](g,key)
	end
end

local function gamepadpressed(g,button)
	local s=g.states
	if _G[Enums.states[s.t]]["gamepadpressed"] then
		_G[Enums.states[s.t]]["gamepadpressed"](g,button)
	end
end

local function draw(g)
	local s=g.states
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