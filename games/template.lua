local template={}

template.make = function(g)

end

template.level={}

template.level.draw = function(g,l)
	--template.level[l.t].draw(g,l)
	--map.draw(l.map,"grid")
	map.draw(l.map,{"numbers"})
end

template.gameplay =
{
	make = function(g)
		level.make(g,1,Enums.modes.topdown)
		local m=g.level.map
		actor.make(g,EA[g.name].template_actor,map.width(m)/2-5,map.height(m)/2-5)
	end,

	keypressed = function(g,key)
		local ease=easing.outElastic
		local dist=300
		local d=300
		if key=='escape' then
			game.state.make(g,"title")
		elseif key=='z' then
			module.make(g.camera,EM.transition,ease,"zoom",g.camera.zoom,4,d)
		elseif key=='x' then
			module.make(g.camera,EM.transition,ease,"zoom",g.camera.zoom,-4,d)
		end
	end,

	draw = function(g)
		LG.print("GAEM_PLAY", g.width/2, g.height/2)
	end
}

template.title =
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
		LG.print("TITLE", g.width/2, g.height/2)
	end
}

template.intro =
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
		LG.print("INTRO", g.width/2, g.height/2)
	end
}

template.option =
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

return template