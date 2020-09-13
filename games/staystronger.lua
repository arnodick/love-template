--TODO RENAME TO STAY STRONGER
local staystronger={}

staystronger.make = function(g)
	g.turn=0
	g.width=200
	g.height=140
	g.rlfont=LG.newFont("fonts/Haeccity DW Bold.ttf",10)
	-- g.rlfont=LG.newFont("fonts/O2.ttf",10)
	-- g.rlfont=LG.newFont("fonts/unifont-10.0.07.ttf",8)
	-- g.rlfont=LG.newFont("fonts/Haeccity DW.ttf",10)
	LG.setFont(g.rlfont)

	g.things={}
	g.things[string.byte(".")] =
	{
		name="road",
		colours={
			{0.5,0.5,0.5}
		}
	}
end

-- staystronger.level={}
-- staystronger.level.make = function(g,l,index,mode)
-- 	l.mode=mode or Enums.modes.roguelike
-- 	l.modename=Enums.modes[mode] or Enums.modes[Enums.modes.roguelike]

-- 	print(l.modename)

-- 	--TODO put this in roguelike? need to add mode.level.make to level.make?
-- 	-- if l.map then
-- 	-- 	l.map.actors={}
-- 	-- 	map.init(l.map.actors,l.map.w,l.map.h)
-- 	-- 	map.generate(l.map.actors,"empty")
-- 	-- 	-- supper.print(l.map.actors)
-- 	-- end
-- end

staystronger.player =
{
	make = function(g,a)
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

staystronger.level = {
	make = function(g,l,index)
		local m=l.map
		g.camera.x=m.width/2
		g.camera.y=m.height/2
	end
}


staystronger.gameplay =
{
	make = function(g)
		-- level.make(g,1,Enums.modes.roguelike)
		level.make(g,1,Enums.modes.roguelike)

		g.step=false

		local a=actor.make(g,EA.rpg_character,g.level.map.w/2,g.level.map.h/2)
		print(a.char)
		print(string.byte(a.char))
		game.player.make(g,a,true)
		a.char='@'
		a.colour={1,1,1}
		local enemy=actor.make(g,EA.rpg_character,2,2)
		enemy.char='$'
		enemy.colour={0.5,0,0}
		-- supper.print(g.level.map.actors)
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

staystronger.actor={}
staystronger.actor.collision = function(g,a,c)
	c.delete=true
	local actormap=g.level.map.actors
	if actormap then
		map.setcellraw(actormap,c.x,c.y,0)
	end
end

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