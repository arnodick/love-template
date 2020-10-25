local collectible={}

collectible.control = function(g,a,gs)
	game.state.run(g.name,"collectible","control",g,a,gs)
end

return collectible