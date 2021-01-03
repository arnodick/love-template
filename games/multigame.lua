local multigame={}

multigame.intro={}
multigame.intro.make = function(g)
	g.window={}
	g.window.width=640
	g.window.height=480
	--excludes defined in game.make so game can decide what to do when pressing escape
	local gamenames={}
	local gamemakes={}
	local gameargs={}
	for i,v in ipairs(Enums.games) do
		if g.excludes[v]==nil then
			table.insert(gamenames,v)
			table.insert(gamemakes,game.make)
			if v=="offgrid" then
				table.insert(gameargs,{i,640,960})
			else
				table.insert(gameargs,{i})
			end
		end
	end

	--TODO send in a menusettings table or something that has textbgcolor="orange" etc?
	module.make(g,g.hud,EM.menu,"interactive",g.width/2,120,g.width-2,(#gamenames+2)*16,gamenames,"orange","dark_green","center",gamemakes,gameargs)
	module.make(g,g.hud.menu,EM.border,"orange","dark_green")
end
multigame.intro.keypressed = function(g,key)
	if key=="escape" then
		love.event.quit()
	elseif key=="up" then
		g.hud.menu.y=g.hud.menu.y-10
		g.camera.y=g.hud.menu.y
	end
	hud.keypressed(g,key)
end

return multigame