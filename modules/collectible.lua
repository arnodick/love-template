local collectible={}

collectible.control = function(a,gs)
	local g=Game
	game.state.run(g.name,"collectible","control",g,a,gs)
end

return collectible