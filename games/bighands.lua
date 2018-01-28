local bighands={}

bighands.level={}

bighands.level.make = function(g,l,index)
	local mw,mh=g.width/g.tile.width,g.height/g.tile.height
	--l.map=map.generate("walls",mw+2,mh+10)
	l.map=map.load("maptest.txt")
	return l
end

bighands.level.draw = function(g,l)
	--map.draw(l.map,{"sprites","grid"})
	map.draw(l.map,{"sprites"})
end

bighands.make = function(g,tw,th,gw,gh,sp)
	
end

bighands.gameplay =
{
	make = function(g)
		hud.make(g)
		love.keyboard.setTextInput(false)
		local zoomchange=4-g.camera.zoom
		module.make(g.camera,EM.transition,easing.inOutSine,"zoom",g.camera.zoom,zoomchange,60)
		level.make(g,1,Enums.games.modes.topdown_tank)
		local m=g.level.map

		for i=1,#Joysticks do
			table.insert(g.players,actor.make(g,EA[g.name].bighands_player,map.width(m)/2,map.height(m)/2+(i*10)))
		end
		
		actor.make(g,EA[g.name].bighands_snake,map.width(m)/2,map.height(m)/2-20)
		
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

bighands.actor = {}

bighands.item =
{
	control = function(g,a,gs)
		players=Game.players
		for i,p in ipairs(players) do
			if actor.collision(a.x,a.y,p) then
				if p.controller.action.action and #p.inventory<1 then
					if a.sound then
						if a.sound.get then
							sfx.play(a.sound.get)
						end
					end
					a.flags=flags.set(a.flags,EF.persistent)
					table.insert(p.inventory,1,a)
				end
			end
		end	
	end,
}

return bighands