local function make(i)

end

local function control()

end

local function keypressed(i,key)
	if key=="space" then
		Game.settings=game.changestate(Enums.states.title)
	end
end

local function gamepadpressed(i,button)
	if button=="start" then
		Game.settings=game.changestate(Enums.states.title)
	end
end

local function draw(i)
	LG.print("INTRO",Game.width/2,Game.height/2)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}