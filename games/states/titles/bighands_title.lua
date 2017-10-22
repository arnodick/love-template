local function make(g)
	
end

local function control(g)
	
end

local function keypressed(g,key)
	if key=="space" or key=="return" then
		state.make(g,Enums.games.states.gameplay,Enums.games.modes.topdown)
	elseif key=='escape' then
		state.make(g,Enums.games.states.intro)
	end
end

local function gamepadpressed(g,button)
	if button=="start" or button=="a" then
		state.make(g,Enums.games.states.gameplay,Enums.games.modes.topdown)
	elseif button=="b" then
		state.make(g,Enums.games.states.intro)
	end
end

local function draw(g)
	LG.print("bighands title", g.width/2, g.height/2)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}