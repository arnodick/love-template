local multigame={}

multigame.intro =
{
	make = function(g)
		local gamenames={}
		local gamemakes={}
		local gameargs={}
		for i,v in ipairs(Enums.games) do
			table.insert(gamenames,v)
			table.insert(gamemakes,game.make)
			table.insert(gameargs,{i})
		end
		module.make(g.hud,EM.menu,EMM.interactive,g.width/2,180,160,120,gamenames,EC.orange,EC.dark_green,"left",gamemakes,gameargs)
	end,

	keypressed = function(g,key)
		if key == 'escape' then
			love.event.quit()
		end
	end,

	draw = function(g)

	end
}

return multigame