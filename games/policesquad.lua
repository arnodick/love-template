local policesquad={}

policesquad.level={}

policesquad.player =
{

}

policesquad.make = function(g)
	
end

policesquad.gameplay =
{
	make = function(g)
		love.keyboard.setTextInput(false)
		-- --local zoomchange=4-g.camera.zoom
		-- --module.make(g.camera,EM.transition,easing.inOutSine,"zoom",g.camera.zoom,zoomchange,60)
		-- level.make(g,1,Enums.modes.topdown_tank)
		-- local m=g.level.map
		-- actor.make(g,EA.witch,map.width(m)/2-5,map.height(m)/2-5)
	end,

	keypressed = function(g,key)
		-- if key=='escape' then
		-- 	game.state.make(g,"title")
		-- end
	end,

	gamepadpressed = function(g,joystick,button)
		-- if button=="start" then
		-- 	g.pause = not g.pause
		-- elseif button=="a" then
		-- 	--print(joystick:getID())
		-- 	if #Joysticks>#g.players then
		-- 		local m=g.level.map
		-- 		local a=actor.make(g,EA.witch,map.width(m)/2,map.height(m)/2)
		-- 		game.player.make(g,a)
		-- 	end
		-- end
	end,

	draw = function(g)
		--LG.print("policesquad gaem",g.width/2,g.height/2)
	end
}

policesquad.title =
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
		elseif button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.print("policesquad title", g.width/2, g.height/2)
	end
}

policesquad.intro =
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
		LG.print("policesquad intro", g.width/2, g.height/2)
	end
}

policesquad.actor = {}

policesquad.item =
{
	control = function(g,a,gs)
		-- local players=g.players
		-- for i,p in ipairs(players) do
		-- 	if actor.collision(a.x,a.y,p) then
		-- 		if p.controller.action.action and #p.inventory<1 then
		-- 			if a.sound then
		-- 				if a.sound.get then
		-- 					sfx.play(a.sound.get)
		-- 				end
		-- 			end
		-- 			a.flags=flags.set(a.flags,EF.persistent)
		-- 			table.insert(p.inventory,1,a)
		-- 		end
		-- 	end
		-- end
	end,

	carry = function(a,user)
		-- a.x=user.hand.x
		-- a.y=user.hand.y
	end,
}

return policesquad