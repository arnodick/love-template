local function make(g,tw,th,gw,gh,sp)
	level.load(g,"games/levels/protosnake/inis")
	g.levelpath={}

	--state.make(g,Enums.games.states.intro)
end

return
{
	make = make,
}