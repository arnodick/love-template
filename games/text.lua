local function make(g,tw,th,gw,gh,sp)
	g.canvas.buffer = LG.newCanvas(gw*0.125,gh*0.125)
	game.state.make(g,Enums.games.states.intro)
end

return
{
	make = make,
}