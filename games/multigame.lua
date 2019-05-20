local multigame={}

multigame.intro =
{
	make = function(g)
		Excludes={dawngame="dawngame",offgrid="offgrid",royalewe="royalewe"}
		local gamenames={}
		local gamemakes={}
		local gameargs={}
		for i,v in ipairs(Enums.games) do
			if Excludes[v]==nil then
				table.insert(gamenames,v)
				table.insert(gamemakes,game.make)
				table.insert(gameargs,{i})
			end
		end

		module.make(g.hud,EM.menu,EMM.interactive,g.width/2,120,160,(#gamenames+2)*12,gamenames,"orange","dark_green","center",gamemakes,gameargs)
		module.make(g.hud.menu,EM.border,"orange","dark_green")
	end,

	keypressed = function(g,key)
		if key=="escape" then
			love.event.quit()
		elseif key=="up" then
			g.hud.menu.y=g.hud.menu.y-10
			g.camera.y=g.hud.menu.y
		end
		hud.keypressed(g,key)
	end,

	draw = function(g)

	end
}

return multigame