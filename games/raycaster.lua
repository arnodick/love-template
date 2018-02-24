local raycaster={}

raycaster.make = function(g)

end

raycaster.level={}

raycaster.level.draw = function(g,l)
	map.draw(l.map,{"numbers"})
end

raycaster.gameplay =
{
	make = function(g)
		level.make(g,1,Enums.modes.topdown)
		local m=g.level.map
		actor.make(g,EA.raycaster_actor,map.width(m)/2-5,map.height(m)/2-5)
	end,

	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end,

	draw = function(g)
		LG.print("RAYCASTER GAEM_PLAY", g.width/2, g.height/2)
	end
}

raycaster.title =
{
	keypressed = function(g,key)
		if key=="space" or key=="return" then
			game.state.make(g,"gameplay")
		elseif key=='escape' then
			game.state.make(g,"intro")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" or button=="a" then
			game.state.make(g,"gameplay")
		end
		if button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.print("RAYCASTER TITLE", g.width/2, g.height/2)
	end
}

raycaster.intro =
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
		LG.print("RAYCASTER INTRO", g.width/2, g.height/2)
	end
}

raycaster.option =
{
	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.print("OPTION",g.width/2,g.height/2)
	end
}

return raycaster