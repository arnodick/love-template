local player={}

player.make = function(g,a)
	g.player=a--TODO make this optional, otherwise just add to g.players
	a.player=true--TODO make this a flag
	game.state.run(g.name,"player","make",g,a)
end

player.control = function(g,a)
	game.state.run(g.name,"player","control",g,a)
end

player.draw = function(g,a)
	game.state.run(g.name,"player","draw",g,a)
end

player.damage = function(g,a)
	game.state.run(g.name,"player","damage",g,a)
end

player.dead = function(g,a)
	game.state.run(g.name,"player","dead",g,a)
end

return player