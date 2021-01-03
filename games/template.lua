local template={}

template.make = function(g)

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

template.level={}

template.gameplay={}
template.gameplay.make = function(g)
	level.make(g,1,Enums.modes.topdown)
	local m=g.level.map
	actor.make(g,"template_actor",m.width/2-5,m.height/2-5)
end
template.gameplay.keypressed = function(g,key)
	local ease=easing.outElastic
	local dist=300
	local d=300
	if key=='escape' then
		game.state.make(g,"title")
	elseif key=='z' then
		module.make(g,g.camera,EM.transition,ease,"zoom",g.camera.zoom,4,d)
	elseif key=='x' then
		module.make(g,g.camera,EM.transition,ease,"zoom",g.camera.zoom,-4,d)
	end
end
template.gameplay.draw = function(g)
	LG.print("GAEM_PLAY", g.width/2, g.height/2)
end

template.title={}
template.title.keypressed = function(g,key)
	if game.keyconfirm(key) then
		game.state.make(g,"gameplay")
	elseif key=='escape' then
		game.state.make(g,"intro")
	end
end
template.title.gamepadpressed = function(g,joystick,button)
	if button=="start" or button=="a" then
		game.state.make(g,"gameplay")
	end
	if button=="b" then
		game.state.make(g,"intro")
	end
end
template.title.draw = function(g)
	LG.print("TITLE", g.width/2, g.height/2)
end

template.intro={}
template.intro.keypressed = function(g,key)
	if game.keyconfirm(key) then
		game.state.make(g,"title")
	end
end
template.intro.gamepadpressed = function(g,joystick,button)
	if button=="start" or button=="a" then
		game.state.make(g,"title")
	end
end
template.intro.draw = function(g)
	LG.print("INTRO", g.width/2, g.height/2)
end

template.option={}
template.option.keypressed = function(g,key)
	if key=='escape' then
		game.state.make(g,"title")
	end
end
template.option.gamepadpressed = function(g,joystick,button)
	if button=="b" then
		game.state.make(g,"intro")
	end
end
template.option.draw = function(g)
	LG.print("OPTION",g.width/2,g.height/2)
end

return template