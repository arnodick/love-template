--TODO RENAME TO STAY STRONGER
local staystronger={}

staystronger.make = function(g)
	g.turn=0
end

staystronger.level={}
staystronger.level.make = function(g,l,index,mode)
	l.mode=mode or Enums.modes.roguelike
	l.modename=Enums.modes[mode] or Enums.modes[Enums.modes.roguelike]

	--TODO put this in roguelike? need to add mode.level.make to level.make?
	-- if l.map then
	-- 	l.map.actors={}
	-- 	map.init(l.map.actors,l.map.w,l.map.h)
	-- 	map.generate(l.map.actors,"empty")
	-- 	-- supper.print(l.map.actors)
	-- end
end

staystronger.player =
{
	make = function(g,a)
		if Joysticks[1] then
			module.make(a,EM.controller,EMC.move,EMCI.gamepad,1,"digital")
			module.make(a,EM.controller,EMC.action,EMCI.gamepad)
		else
			module.make(a,EM.controller,EMC.move,EMCI.keyboard,"direct")
			module.make(a,EM.controller,EMC.action,EMCI.keyboard)
		end
	end,

	control = function(g,a)
		if SFX.positonal then
			love.audio.setPosition(a.x,a.y,0)
		end

		-- print(g.step)

		g.step=false
		if a.controller.move.horizontal~=0 then
			if a.controller.move.last.horizontal==0 then
				print(g.turn)
				-- print(g.player.x)
				g.step=true
				g.turn=g.turn+1
			end
		elseif a.controller.move.vertical~=0 then
			if a.controller.move.last.vertical==0 then
				print(g.turn)
				g.step=true
				g.turn=g.turn+1
			end
		end

		if a.controller.action.use then
			a.c="red"
		else
			a.c=a.cinit
		end
	end,
}

staystronger.gameplay =
{
	make = function(g)
		-- level.make(g,1,Enums.modes.roguelike)
		level.make(g,1)

		g.step=false

		local a=actor.make(g,EA.rpg_character,g.level.map.w/2,g.level.map.h/2)
		print(a.char)
		print(string.byte(a.char))
		game.player.make(g,a,true)
		actor.make(g,EA.rpg_character,2,2)
	end,

	control = function(g)
		--g.step=false
	end,

	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end,
}

staystronger.title =
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
		LG.print("staystronger title", g.width/2, g.height/2)
	end
}

staystronger.intro =
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
		LG.print("staystronger intro", g.width/2, g.height/2)
	end
}

staystronger.option =
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
		LG.print("staystronger options",g.width/2,g.height/2)
	end
}

return staystronger