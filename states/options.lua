local function make(g)
	music.play(1)
end


local function control(g)
end

local function keypressed(g,key)
	if key=='escape' then
		game.state.make(g,Enums.states.title)
	end
end

local function gamepadpressed(g,button)
end

local function draw(g)
	LG.print("OPTIONS",g.width/2,g.height/2)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}