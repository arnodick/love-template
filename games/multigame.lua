local multigame={}

multigame.intro =
{
	keypressed = function(g,key)
		if key == 'escape' then
			love.event.quit()
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" or button=="a" then
			Game = game.make(Enums.games.bighands,8,8,640,480,1)
		elseif button=="x" then
			Game = game.make(Enums.games.protosnake,8,8,320,240,1)
		end
	end,

	draw = function(g)
		LG.print("PRESS A TO LOAD WITCHEZ AND WIZ", g.width/2, g.height/2)
		LG.print("PRESS X TO LOAD PROTOSNAKE", g.width/2, g.height/2+20)
	end
}

return multigame