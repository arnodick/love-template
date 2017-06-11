local function make(g,tw,th,gw,gh,sp)
	g.pt=Enums.physics.topdown
	game.state.make(g,Enums.states.intro)
end

return
{
	make = make,
}