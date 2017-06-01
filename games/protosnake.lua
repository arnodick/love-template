local function make(g,tw,th,gw,gh,sp)
	g.pt=Enums.physics.topdown
	g.levels=level.load("levels/inis")
	g.levelpath={}
	--debugger.printtable(g.levels)

	game.state.make(g,Enums.states.intro)
end

return
{
	make = make,
}