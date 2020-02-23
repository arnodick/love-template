local policesquad={}

policesquad.level={}

policesquad.player =
{

}

policesquad.make = function(g)
	g.character={}
	g.character.name="Chief Zigler"
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
 		if love.keyboard.isDown("lctrl") then
			if key=='s' then
				json.save("plcesqd.json",g.character)
				module.make(g.hud,EM.menu,"text",100,100,200,200,g.character.name.." SAVED!","orange","dark_green")
				local menu_destroy = function(m)
					-- if (g.hud.menu) then
					-- 	g.hud.menu=nil
					-- end
					print("MENU DESTROYED "..tostring(m))
					m.menu=nil
					print("MENU DESTROYED AFTER "..tostring(m))
					print("HUD MENU AFTER "..tostring(g.hud.menu))
				end
				print("MENU CREATED "..tostring(g.hud.menu))
				module.make(g.hud.menu,EM.transition,easing.linear,"destroy",0,1,180,menu_destroy,g.hud,EM.transitions.destroy)
			end
		elseif key=='escape' then
			game.state.make(g,"title")
		elseif key=='d' then
			dicey.dice(6,5,true)
		elseif key=='r' then
			dicey.iterate(10,6,3,true)
		end
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