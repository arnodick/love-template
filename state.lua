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

local function change(g,s)
	local e=Enums
	--initializes game's state, timer, camera, actor, menu and state tables
	g.state=s
	g.timer=0
	g.speed=1
	g.camera=camera.make(0,0)
	g.actors={}
	g.menus={}
	g.states={}
	table.insert(g.states,state.make(s))--TODO can probably do away with state table, just one Game.state variable?
	g.counters=counters.init()

	if _G[Enums.states[s.t]]["change"] then
		_G[Enums.states[s.t]]["change"](g,s)
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
	change = change,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}