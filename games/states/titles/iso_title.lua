local function make(g)

end

local function control(g)

end

local function keypressed(g,key)
	if key=="space" or key=="return" then
		game.state.make(g,"gameplay",Enums.games.modes.isometric)
	elseif key=='escape' then
		game.state.make(g,"intro")
	end
end

local function gamepadpressed(g,button)
	if button=="start" or button=="a" then
		game.state.make(g,"gameplay",Enums.games.modes.isometric)
	end
	if button=="b" then
		game.state.make(g,"intro")
	end
end

local function draw(g)
	LG.print("rpg title", g.width/2, g.height/2)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}