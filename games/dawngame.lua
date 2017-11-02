local iso={}

iso.make = function(g,tw,th,gw,gh,sp)

end

iso.gameplay =
{
	make = function(g)

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

iso.title =
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
		end
		if button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.print("DAWN GAME", g.width/2, g.height/2)
	end
}

iso.intro =
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
		LG.print("INTRO", g.width/2, g.height/2)
	end
}

iso.option =
{
	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,button)
		if button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.print("OPTION",g.width/2,g.height/2)
	end
}

return iso