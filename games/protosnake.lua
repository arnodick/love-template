local function make(g,tw,th,gw,gh,sp)
	level.load(g,"games/levels/protosnake/inis")
	g.levelpath={}

	--game.state.make(g,Enums.games.states.intro)
end

return
{
	make = make,
}