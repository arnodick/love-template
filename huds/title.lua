local function make(t)

end


local function control(t)

end

local function keypressed(t,key)
	if key=="space" then
		game.changestate(Game,Enums.states.play)
	end
end

local function gamepadpressed(i,button)
	if button=="start" then
		game.changestate(Game,Enums.states.play)
	end
end

local function draw(t)
	LG.print("TITLE",Game.width/2,Game.height/2)
	scores.draw(Game.width/2,Game.height/2,EC.white,EC.yellow)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}