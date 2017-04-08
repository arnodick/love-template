local function make(g,t)--initializes game's state, timer, camera, actor, menu and state tables
	local e=Enums
	g.state={}
	g.state.t=t
	g.timer=0
	g.speed=1
	g.camera=camera.make(0,0)
	g.actors={}
	g.menus={}
	g.counters=counters.init()
	for i,v in pairs(g.canvas) do
		LG.setCanvas(v)
		LG.clear()
	end
	for i,v in pairs(SFX.sources) do
		v:stop()
	end
	for i,v in pairs(Music.sources) do
		v:stop()
	end
	if _G[e.states[g.state.t]]["make"] then
		_G[e.states[g.state.t]]["make"](g)
	end
end

local function control(g)
	local s=g.state
	if _G[Enums.states[s.t]]["control"] then
		_G[Enums.states[s.t]]["control"](g)
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
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}