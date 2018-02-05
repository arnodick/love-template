local rpg={}

rpg.make = function(g)

end

rpg.gameplay =
{
	make = function(g)
		local mw,mh=g.width/g.tile.width,g.height/g.tile.height
		--g.map=map.generate("random",mw+2,mh+2)
		g.map=map.generate("walls",mw+2,mh+2)

		g.step=false

		g.player=actor.make(g,EA[g.name].rpg_player,g.width/2,g.height/2)
		actor.make(g,EA[g.name].rpg_enemy,g.width/2,g.height/2)
	end,

	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end
}

rpg.title =
{
	keypressed = function(g,key)
		if key=="space" or key=="return" then
			game.state.make(g,"gameplay")
		elseif key=='escape' then
			game.state.make(g,"intro")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="b" then
			game.state.make(g,"intro")
		elseif button=="a" then
			game.state.make(g,"gameplay")
		end
	end,

	draw = function(g)
		LG.print("rpg title", g.width/2, g.height/2)
	end
}

rpg.intro =
{
	keypressed = function(g,key)
		if key=="space" or key=="return" then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" or button=="a" then
			game.state.make(g,"title")
		end
	end,

	draw = function(g)
		LG.print("rpg intro", g.width/2, g.height/2)
	end
}

rpg.option =
{
	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function (g,joystick,button)
		if button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.print("rpg options",g.width/2,g.height/2)
	end
}

return rpg