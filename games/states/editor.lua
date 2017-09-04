local function make(g)
	if _G[Enums.games.states.editors[g.state.st]]["make"] then
		_G[Enums.games.states.editors[g.state.st]]["make"](g)
	end
end

local function control(g)
	if _G[Enums.games.states.editors[g.state.st]]["control"] then
		_G[Enums.games.states.editors[g.state.st]]["control"](g)
	end
end

local function keypressed(g,key)
	if key=="escape" then
		game.state.make(g,Enums.games.states.gameplay)
	end
	if _G[Enums.games.states.editors[g.state.st]]["keypressed"] then
		_G[Enums.games.states.editors[g.state.st]]["keypressed"](g,key)
	end
end

local function gamepadpressed(g,button)
	if _G[Enums.games.states.editors[g.state.st]]["gamepadpressed"] then
		_G[Enums.games.states.editors[g.state.st]]["gamepadpressed"](g,button)
	end
end

local function draw(g)
	LG.print("EDITOR",g.width/2,g.height/2)
	if _G[Enums.games.states.editors[g.state.st]]["draw"] then
		_G[Enums.games.states.editors[g.state.st]]["draw"](g)
	end
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}