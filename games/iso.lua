local function make(g,tw,th,gw,gh,sp)
	game.state.make(g,Enums.games.states.gameplay)
end

return
{
	make = make,
}