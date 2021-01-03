local iso={}

iso.level={}

iso.make = function(g)

end

iso.gameplay={}
iso.gameplay.make = function(g)
	level.make(g,1,Enums.modes.isometric)
end
iso.gameplay.keypressed = function(g,key)
	if key=='escape' then
		game.state.make(g,"title")
	elseif key=='space' then
		--g.timer=0
	end

	local ease=easing.outElastic
	local dist=300
	local d=300
	if key=='right' then
		module.make(g,g.camera,EM.transition,ease,"x",g.camera.x,dist,d)
	elseif key=='left' then
		module.make(g,g.camera,EM.transition,ease,"x",g.camera.x,-dist,d)
	elseif key=='up' then
		module.make(g,g.camera,EM.transition,ease,"y",g.camera.y,-dist,d)
	elseif key=='down' then
		module.make(g,g.camera,EM.transition,ease,"y",g.camera.y,dist,d)
	end

	if key=='z' then
		module.make(g,g.camera,EM.transition,ease,"zoom",g.camera.zoom,4,d)
	elseif key=='x' then
		module.make(g,g.camera,EM.transition,ease,"zoom",g.camera.zoom,-4,d)
	end
end

iso.title={}
iso.title.keypressed = function(g,key)
	if game.keyconfirm(key) then
		game.state.make(g,"gameplay")
	elseif key=='escape' then
		game.state.make(g,"intro")
	end
end
iso.title.gamepadpressed = function(g,joystick,button)
	if button=="start" or button=="a" then
		game.state.make(g,"gameplay")
	end
	if button=="b" then
		game.state.make(g,"intro")
	end
end
iso.title.draw = function(g)
	LG.print("rpg title", g.width/2, g.height/2)
end

iso.intro={}
iso.intro.keypressed = function(g,key)
	if game.keyconfirm(key) then
		game.state.make(g,"title")
	end
end
iso.intro.gamepadpressed = function(g,joystick,button)
	if button=="start" or button=="a" then
		game.state.make(g,"title")
	end
end
iso.intro.draw = function(g)
	LG.print("rpg intro", g.width/2, g.height/2)
end

iso.option={}
iso.option.keypressed = function(g,key)
	if key=='escape' then
		game.state.make(g,"title")
	end
end
iso.option.gamepadpressed = function(g,joystick,button)
	if button=="b" then
		game.state.make(g,"intro")
	end
end
iso.option.draw = function(g)
	LG.print("rpg options",g.width/2,g.height/2)
end

return iso