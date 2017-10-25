local state={}

state.make = function(g,t,mode,st)
	--initializes game's state, timer, camera, actor, menu and state tables
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
	run(e.games.states[g.state.t],"make",g)
end

return state