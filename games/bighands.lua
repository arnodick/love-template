local bighands={}

bighands.level={}

bighands.level.make = function(g,l,index)
	local mw,mh=g.width/g.tile.width,g.height/g.tile.height
	l.map=map.generate("walls",mw+2,mh+2)
	return l
end

bighands.make = function(g,tw,th,gw,gh,sp)

end

bighands.gameplay =
{
	make = function(g)
		level.make(g,1,Enums.games.modes.topdown_tank)
		g.players={}
		table.insert(g.players,actor.make(g,EA[g.name].bighands_player,g.width/2,g.height/2))
		table.insert(g.players,actor.make(g,EA[g.name].bighands_player,g.width/2,g.height/2+50))
		actor.make(g,EA[g.name].bighands_snake,g.width/2,g.height/2-20)
		
		--table.insert(g.players,actor.make(g,EA[g.name].bighands_player,g.width/2,g.height/2))
		--g.player=actor.make(g,EA[g.name].bighands_player,g.width/2,g.height/2)
	end,

	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,button)
		if button=="start" then
			g.pause = not g.pause
		end

	end,

	draw = function(g)
		--LG.print("bighands gaem",g.width/2,g.height/2)
	end
}

bighands.title =
{
	keypressed = function(g,key)
		if key=="space" or key=="return" then
			game.state.make(g,"gameplay")
		elseif key=='escape' then
			game.state.make(g,"intro")
		end
	end,

	gamepadpressed = function(g,button)
		if button=="start" or button=="a" then
			game.state.make(g,"gameplay")
		elseif button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.print("bighands title", g.width/2, g.height/2)
	end
}

bighands.intro =
{
	keypressed = function(g,key)
		if key=="space" or key=="return" then
			game.state.make(g,"title")
		elseif key == 'escape' then
			love.event.quit()
		end
	end,

	gamepadpressed = function(g,button)
		if button=="start" or button=="a" then
			game.state.make(g,"title")
		end
	end,

	draw = function(g)
		LG.print("bighands intro", g.width/2, g.height/2)
	end
}

return bighands