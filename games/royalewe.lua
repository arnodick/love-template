local royalewe={}

royalewe.level={}

royalewe.player =
{
	make = function(g,a)
		local playernum=#g.players
		print(playernum)

		if #Joysticks>0 then
			module.make(a,EM.controller,EMC.move,EMCI.gamepad,playernum)
			module.make(a,EM.controller,EMC.aim,EMCI.gamepad,playernum)
			module.make(a,EM.controller,EMC.action,EMCI.gamepad,playernum)
		end

		actor.make(g,EA.wand,a.x+20,a.y)

--[[
		a.hand={l=8,d=math.pi/4,x=0,y=0}
		a.hand.x=a.x+(math.cos(a.d+a.hand.d)*a.hand.l)
		a.hand.y=a.y+(math.sin(a.d+a.hand.d)*a.hand.l)
--]]
	end,

	control = function(g,a)
		g.camera.x=a.x
		g.camera.y=a.y
	end,
}

royalewe.make = function(g)
	
end

royalewe.gameplay =
{
	make = function(g)
		love.keyboard.setTextInput(false)
		level.make(g,1,Enums.modes.topdown_tank)
		local m=g.level.map
		--actor.make(g,EA.witch,map.width(m)/2-5,map.height(m)/2-5)
		g.camera.zoom=2
		for i=1,99 do
			actor.make(g,EA.witch,love.math.random(m.w),love.math.random(m.h))
		end
	end,

	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" then
			g.pause = not g.pause
		elseif button=="a" then
			--print(joystick:getID())
			if #Joysticks>#g.players then
				local m=g.level.map
				local a=actor.make(g,EA.witch,20,20)
				player.make(g,a)
			end
		end
	end,

	draw = function(g)
		--LG.print("royalewe gaem",g.width/2,g.height/2)
	end
}

royalewe.title =
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
		LG.print("royalewe title", g.width/2, g.height/2)
	end
}

royalewe.intro =
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
		LG.print("royalewe intro", g.width/2, g.height/2)
	end
}

royalewe.actor = {}

royalewe.item =
{
	control = function(g,a,gs)
		local players=g.players
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

	carry = function(a,user)
		a.x=user.hand.x
		a.y=user.hand.y
	end,
}

return royalewe