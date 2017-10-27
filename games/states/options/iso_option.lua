local function make(g)

end

local function control(g)

end

local function keypressed(g,key)
	if key=='escape' then
		game.state.make(g,"title")
	end
end

local function gamepadpressed(g,button)
	if button=="b" then
		game.state.make(g,"intro")
	end
end

local function draw(g)
	LG.print("rpg options",g.width/2,g.height/2)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}