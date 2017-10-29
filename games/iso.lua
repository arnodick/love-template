local iso={}

iso.make = function(g,tw,th,gw,gh,sp)

end

iso.gameplay =
{
	make = function(g)
		local mw,mh=g.width/g.tile.width,g.height/g.tile.height
		g.map=map.generate({"random","walls"},mw,mh,{pool={1,1,1,1,2,3,4}})
		--g.map=map.generate({"random"},mw,mh,{pool={1,1,1,1,2,3,4}})

		g.player=actor.make(EA[g.name].iso_player,g.width/2,g.height/2)

		g.camera.x=50
		g.camera.y=100
	end,

	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		elseif key=='space' then
			local mw,mh=g.width/g.tile.width,g.height/g.tile.height
			g.timer=0
			g.map=map.generate("random",mw,mh,{pool={1,1,1,1,2,3,4}})
		end

		local ease=easing.outElastic
		local dist=300
		local d=300
		if key=='right' then
			module.make(g.camera,EM.transition,ease,"x",g.camera.x,dist,d)
		elseif key=='left' then
			module.make(g.camera,EM.transition,ease,"x",g.camera.x,-dist,d)
		elseif key=='up' then
			module.make(g.camera,EM.transition,ease,"y",g.camera.y,-dist,d)
		elseif key=='down' then
			module.make(g.camera,EM.transition,ease,"y",g.camera.y,dist,d)
		end

		if key=='z' then
			module.make(g.camera,EM.transition,ease,"zoom",g.camera.zoom,4,d)
		elseif key=='x' then
			module.make(g.camera,EM.transition,ease,"zoom",g.camera.zoom,-4,d)
		end
	end,

	draw = function(g)
		map.draw(g.map,"isometric")--TODO make isometric levels so this draw doesn't go over the actors
	end
}

iso.title =
{
	keypressed = function(g,key)
		if key=="space" or key=="return" then
			game.state.make(g,"gameplay",Enums.games.modes.isometric)
		elseif key=='escape' then
			game.state.make(g,"intro")
		end
	end,

	gamepadpressed = function(g,button)
		if button=="start" or button=="a" then
			game.state.make(g,"gameplay",Enums.games.modes.isometric)
		end
		if button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.print("rpg title", g.width/2, g.height/2)
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
		LG.print("rpg intro", g.width/2, g.height/2)
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
		LG.print("rpg options",g.width/2,g.height/2)
	end
}

return iso