local hud={}

hud.make = function(g,...)
	g.hud={}
	if _G[g.name][g.state].hud then
		_G[g.name][g.state].hud.make(g,g.hud,...)
	end
end

hud.control = function(g,h)
	if h.menu then
		--g.hud.menu.x=g.camera.x
		--g.hud.menu.y=g.camera.y
		menu.control(g,h.menu,g.speed)
	end
end

hud.draw = function(g,h,...)
	if _G[g.name][g.state].hud then
		_G[g.name][g.state].hud.draw(g,h,...)
	end

	if Debugger.debugging then
		if g.level then
			if g.level.map then
				map.draw(g,g.level.map,"points")
			end
		end
	end

	if h.menu then
		menu.draw(h.menu)
	end
end

hud.keypressed = function(g,key)
	local m=g.hud.menu
	if m then
		menu.keypressed(m,key)
	end
end

hud.gamepadpressed = function(g,joystick,button)
	local m=g.hud.menu
--TODO comment this out and see if it still works after generalized to game
	if m then
		menu.gamepadpressed(m,button)
	end
end

return hud