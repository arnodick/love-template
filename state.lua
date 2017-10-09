local function make(g,t,mode,st)--initializes game's state, timer, camera, actor, menu and state tables
	local e=Enums
	g.state={}
	g.state.t=t
	g.state.mode=mode
	g.state.modename=Enums.games.modes[mode]
	if st then
		g.state.st=st
	else
		local statename=Enums.games.states[t]
		local gamename=Enums.games[g.t]
		g.state.st=Enums.games.states[statename.."s"][gamename.."_"..statename]
	end
	g.timer=0
	g.speed=1
	g.camera=camera.make(g.width/2,g.height/2)
	g.actors={}
	g.counters=counters.init(g.t)
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
	screen.update(g)
	if _G[e.games.states[g.state.t]]["make"] then
		_G[e.games.states[g.state.t]]["make"](g)
	end
end

local function control(g)
	local s=g.state
	if _G[Enums.games.states[s.t]]["control"] then
		_G[Enums.games.states[s.t]]["control"](g)
	end
	if g.editor then
		editor.control(g)
	end
end

local function keypressed(g,key)
	local s=g.state
	if _G[Enums.games.states[s.t]]["keypressed"] then
		_G[Enums.games.states[s.t]]["keypressed"](g,key)
	end
	if g.editor then
		editor.keypressed(g,key)
	end
end

local function keyreleased(g,key)
	local s=g.state
	if _G[Enums.games.states[s.t]]["keyreleased"] then
		_G[Enums.games.states[s.t]]["keyreleased"](g,key)
	end
end

local function mousepressed(g,x,y,button)
	local s=g.state
	if _G[Enums.games.states[s.t]]["mousepressed"] then
		_G[Enums.games.states[s.t]]["mousepressed"](g,x,y,button)
	end
	if g.editor then
		editor.mousepressed(g,x,y,button)
	end
end

local function wheelmoved(g,x,y)
	local s=g.state
	if _G[Enums.games.states[s.t]]["wheelmoved"] then
		_G[Enums.games.states[s.t]]["wheelmoved"](g,x,y)
	end
	if g.editor then
		editor.wheelmoved(g,x,y)
	end
end

local function gamepadpressed(g,button)
	local s=g.state
	if _G[Enums.games.states[s.t]]["gamepadpressed"] then
		_G[Enums.games.states[s.t]]["gamepadpressed"](g,button)
	end
	if g.editor then
		editor.gamepadpressed(g,button)
	end
end

local function draw(g)
	local s=g.state
	if _G[Enums.games.states[s.t]]["draw"] then
		_G[Enums.games.states[s.t]]["draw"](g)
	end
	if g.editor then
		editor.draw(g)
	end
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	keyreleased = keyreleased,
	mousepressed = mousepressed,
	wheelmoved = wheelmoved,
	gamepadpressed = gamepadpressed,
	draw = draw,
}