--TODO RENAME TO STAY STRONGER
local staystronger={}

staystronger.make = function(g)
	g.turn=0
	g.width=200
	g.height=140
	g.rlfont=LG.newFont("fonts/Haeccity DW Bold.ttf",10)
	g.rlfont2=LG.newFont("fonts/Kongtext Regular.ttf",8)
	-- g.rlfont=LG.newFont("fonts/O2.ttf",10)
	-- g.rlfont=LG.newFont("fonts/unifont-10.0.07.ttf",8)
	-- g.rlfont=LG.newFont("fonts/Haeccity DW.ttf",10)
	LG.setFont(g.rlfont)

	g.charset={'!','"','#','$','%','&','\'','(',')','*','+',',','-','.','/','0','1','2','3','4','5','6','7','8','9',':',';','<','=','>','?','@','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','[','\\',']','^','_','`','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','{','|','}','~','Ç','ü','é','â','ä','à','å','ç','ê','ë','è','ï','î','ì','Ä','Å','É','æ','Æ','ô','ö','ò','û','ù','ÿ','Ö','Ü','¢','£','¥','₧','ƒ','á','í','ó','ú','ñ','Ñ','ª','º','¿','⌐','¬','½','¼','¡','«','»','░','▒','▓','│','┤','╡','╢','╖','╕','╣','║','╗','╝','╜','╛','┐','└','┴','┬','├','─','┼','╞','╟','╚','╔','╩','╦','╠','═','╬','╧','╨','╤','╥','╙','╘','╒','╓','╫','╪','┘','┌','█','▄','▌','▐','▀','α','ß','Γ','π','Σ','σ','µ','τ','Φ','Θ','Ω','δ','∞','φ','ε','∩','≡','±','≥','≤','⌠','⌡','÷','≈','°','∙','·','√','ⁿ','²','■'}
	supper.numbers(g.charset)

	print(#g.charset)
	-- supper.print(g.charset)

	-- for i,v in ipairs(g.charset) do
	-- 	print(v)
	-- end

	-- print(string.byte("·"))
	-- print(string.byte("."))
	-- print(string.char(194))
	-- print(string.char(128))
	-- print(string.char(129))
	g.things={}
	g.things[g.charset["·"]] =
	{
		name="road",
		colours={
			{0.5,0.5,0.5}
		},
		-- backgroundcolour={0.1,0.7,0.3}
	}
	g.things[g.charset["/"]] =
	{
		name="grass",
		colours={
			{0,   0.52,0.05},
			{0.17,0.55,0   },
			{0,   0.48,0.29},
			{0,   0.62,0.29},
			{0.08,0.38,0   },
		},
		characters={
			"}","/","/","^","}"
		},
		chance={
			true,true,false
		},
		font=g.rlfont2
		-- backgroundcolour={0.1,0.7,0.3}
	}
	g.things[g.charset["I"]] =
	{
		name="pillar",
		colours={
			{0.25,0.25,0.25},
		},
		font=g.rlfont2
		-- backgroundcolour={0.1,0.7,0.3}
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
				-- print(g.turn)
				-- print(g.player.x)
				g.step=true
				g.turn=g.turn+1
			end
		elseif a.controller.move.vertical~=0 then
			if a.controller.move.last.vertical==0 then
				-- print(g.turn)
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

		for i,v in ipairs(m) do
			local x,y=map.getxy(m,i)
			local value=map.getcellvalue(m,x,y,true)
			local object=g.things[value]
			if object then
				if object.chance then
					if not math.choose(unpack(object.chance)) then
						map.setcellraw(m,x,y,0)
					end
				end
			end
		end
	end
}

staystronger.level.outofbounds = function(g,a,hor)
	if flags.get(a.flags,EF.player) then
		print("YES")
		a.x=5
		a.y=5
		level.make(g,2,Enums.modes.roguelike)
	else
		a.delete=true
	end
end


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
		-- a.char=g.charset[186]
		a.colour={1,1,1}
		local enemy=actor.make(g,EA.rpg_character,2,2)
		enemy.char='$'
		-- enemy.char=g.charset[221]
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
		if key=="space" or key=="return" or key=='z' then
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
		if key=="space" or key=="return" or key=='z' then
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