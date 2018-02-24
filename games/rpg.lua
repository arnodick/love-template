local rpg={}

rpg.make = function(g)

end

rpg.level={}

rpg.player =
{
	make = function(g,a)
		module.make(a,EM.controller,EMC.move,EMCI.keyboard)
		module.make(a,EM.controller,EMC.action,EMCI.keyboard)
	end,

	control = function(g,a)
		if SFX.positonal then
			love.audio.setPosition(a.x,a.y,0)
		end

		g.step=false
		if a.controller.move.horizontal~=0 then
			if a.controller.move.last.horizontal==0 then
				g.step=true
			end
		end
		if a.controller.move.vertical~=0 then
			if a.controller.move.last.vertical==0 then
				g.step=true
			end
		end

		if a.controller.action.use then
			a.c=EC.red
		else
			a.c=a.cinit
		end
	end,
}

rpg.gameplay =
{
	make = function(g)
		level.make(g,1,Enums.modes.roguelike)

		g.step=false

		local a=actor.make(g,EA[g.name].rpg_character,g.level.map.w/2,g.level.map.h/2)
		player.make(g,a,true)
		actor.make(g,EA[g.name].rpg_character,2,2)
	end,

	control = function(g)
		--g.step=false
	end,

	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end,

	draw = function(g)
		map.draw(g.level.map,{"grid","sprites"})
	end,
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