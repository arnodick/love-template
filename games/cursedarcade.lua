local cursedarcade={}

cursedarcade.make = function(g)

end

cursedarcade.player={}
cursedarcade.player.control = function(g,a)
	a.rays={}
	local x=1
	-- for i=-1/2,1/2,0.01 do
	for i=-1,1,0.01 do
		local r=raycast.castray(g,a.x,a.y,a.d+i,30,0.1)
		r.len=r.len*math.cos(i)--TODO why just cos here?
		r.x=x
		x=x+1
		table.insert(a.rays,r)
	end
	local function raysort(a,b)
		if a.len<b.len then
			return true
		else
			return false
		end
	end
	table.sort(a.rays,raysort)
end

cursedarcade.actor={}
cursedarcade.actor.make = function(g,a,c,size,spr,hp)
	a.size=size or 1
	a.spr=spr or 193
	a.hp=hp or 8

	module.make(g,a,EM.sound,4,"damage")
	module.make(g,a,EM.hitradius,4)
	module.make(g,a,EM.inventory,1)

	a.flags=flags.set(a.flags,EF.damageable,EF.shootable)
end

cursedarcade.level={}

cursedarcade.gameplay={}
cursedarcade.gameplay.make = function(g)
	level.make(g,1,Enums.modes.raycast)
	local m=g.level.map
	local a=actor.make(g,"template_actor",m.width/2-5,m.height/2-5)
	game.player.make(g,a,true)
	-- g.clear=true
end
cursedarcade.gameplay.keypressed = function(g,key)
	if key=='escape' then
		game.state.make(g,"title")
	end
end
cursedarcade.gameplay.draw = function(g)
	-- LG.print("RAYCASTER GAEM_PLAY", g.width/2, g.height/2)
end

cursedarcade.title={}
cursedarcade.title.keypressed = function(g,key)
	if game.keyconfirm(key) then
		game.state.make(g,"gameplay")
	elseif key=='escape' then
		game.state.make(g,"intro")
	end
end
cursedarcade.title.gamepadpressed = function(g,joystick,button)
	if button=="start" or button=="a" then
		game.state.make(g,"gameplay")
	end
	if button=="b" then
		game.state.make(g,"intro")
	end
end
cursedarcade.title.draw = function(g)
	LG.print("RAYCASTER TITLE", g.width/2, g.height/2)
end

cursedarcade.intro={}
cursedarcade.intro.keypressed = function(g,key)
	if game.keyconfirm(key) then
		game.state.make(g,"title")
	end
end
cursedarcade.intro.gamepadpressed = function(g,joystick,button)
	if button=="start" or button=="a" then
		game.state.make(g,"title")
	end
end
cursedarcade.intro.draw = function(g)
	LG.print("RAYCASTER INTRO", g.width/2, g.height/2)
end

cursedarcade.option={}
cursedarcade.option.keypressed = function(g,key)
	if key=='escape' then
		game.state.make(g,"title")
	end
end
cursedarcade.option.gamepadpressed = function(g,joystick,button)
	if button=="b" then
		game.state.make(g,"intro")
	end
end
cursedarcade.option.draw = function(g)
	LG.print("OPTION",g.width/2,g.height/2)
end

return cursedarcade