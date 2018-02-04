local multigame={}

multigame.intro =
{
	make = function(g)
		--Game = game.make(Enums.games.multigame)
		game.make(Enums.games.multigame)
		--module.make(g.hud,EM.menu,EMM.interactive,g.width/2,180,60,30,{"START","OPTIONS"},EC.orange,EC.dark_green,"left",{game.state.make,game.state.make},{{g,"gameplay"},{g,"option"}})
		--module.make(g.hud,EM.menu,EMM.interactive,g.width/2,180,60,30,{"PROTOSNAKE","WITCHEZ & WIZZEZ"},EC.orange,EC.dark_green,"left",{game.make,game.make},{{g,"gameplay"},{g,"option"}})
	end,

	keypressed = function(g,key)
		if key == 'escape' then
			love.event.quit()
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" or button=="a" then
			--Game = game.make(Enums.games.bighands,8,8,640,480,1)
			game.make(Enums.games.bighands,8,8,640,480,1)
		elseif button=="x" then
			--Game = game.make(Enums.games.protosnake,8,8,320,240,1)
			game.make(Enums.games.protosnake,8,8,320,240,1)
		end
	end,

	draw = function(g)
		LG.print("PRESS A TO LOAD WITCHEZ AND WIZ", g.width/2, g.height/2)
		LG.print("PRESS X TO LOAD PROTOSNAKE", g.width/2, g.height/2+20)
	end
}

return multigame