local function make(g)
	if _G[Enums.states.options[g.state.st]]["make"] then
		_G[Enums.states.options[g.state.st]]["make"](g)
	end
end


local function control(g)
end

local function keypressed(g,key)
	if key=='escape' then
		game.state.make(g,Enums.states.title)
	end
end

local function gamepadpressed(g,button)
	if button=="b" then
		game.state.make(g,Enums.states.intro,Enums.states.intros.intro_protosnake)
	end
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