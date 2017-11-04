local template={}

template.make = function(g,tw,th,gw,gh,sp)

end

template.level={}
template.level.LEVELTYPE=
{
	make = function(g,l)
		--local mw,mh=g.width/g.tile.width,g.height/g.tile.height
		--l.map=map.generate("walls",mw+2,mh+2)
	end,

	control = function(g,l)
	end,

	draw = function(g,l)
	end
}

template.level.make = function(g,l,index)
	local lload=g.levels[index]

	l.t=lload.values.t
	--DO LEVEL LOADING STUFF HERE

	--template.level[l.t].make(g,l)
	return l
end

template.level.control = function(g,l)
	--template.level[l.t].control(g,l)
end

template.level.draw = function(g,l)
	--template.level[l.t].draw(g,l)
	--map.draw(l.map,"grid")
end

template.gameplay =
{
	make = function(g)

	end,

	keypressed = function(g,key)
		local ease=easing.outElastic
		local dist=300
		local d=300
		if key=='escape' then
			game.state.make(g,"title")
		elseif key=='z' then
			module.make(g.camera,EM.transition,ease,"zoom",g.camera.zoom,4,d)
		elseif key=='x' then
			module.make(g.camera,EM.transition,ease,"zoom",g.camera.zoom,-4,d)
		end
	end,

	draw = function(g)
		LG.print("GAEM_PLAY", g.width/2, g.height/2)
	end
}

template.title =
{
	keypressed = function(g,key)
		if key=="space" or key=="return" then
			game.state.make(g,"gameplay")
		elseif key=='escape' then
			game.state.make(g,"intro")
		end
	end,

	gamepadpressed = function(g,button)
		if button=="start" or button=="a" then
			game.state.make(g,"gameplay")
		end
		if button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.print("TITLE", g.width/2, g.height/2)
	end
}

template.intro =
{
	keypressed = function(g,key)
		if key=="space" or key=="return" then
			game.state.make(g,"title")
		elseif key == 'escape' then
			love.event.quit()
		end
	end,

	gamepadpressed = function(g,button)
		if button=="start" or button=="a" then
			game.state.make(g,"title")
		end
	end,

	draw = function(g)
		LG.print("INTRO", g.width/2, g.height/2)
	end
}

template.option =
{
	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,button)
		if button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.print("OPTION",g.width/2,g.height/2)
	end
}

return template