local function make(g,tw,th,gw,gh,sp)
	g.levels=level.load("levels/protosnake/inis")
	g.levelpath={}

	game.state.make(g,Enums.states.intro)
end

return
{
	make = make,
}