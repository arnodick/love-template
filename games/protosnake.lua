local function make(g,tw,th,gw,gh,sp)
	level.load(g,"games/levels/protosnake/inis")
	g.levelpath={}

	state.make(g,Enums.games.states.intro)
end


--TODO can probably strip out all these state.control things and put them right in game library
local function control(g)
	state.control(g)
end

local function keypressed(g,key,scancode,isrepeat)
	state.keypressed(g,key)
end

local function mousepressed(g,x,y,button)
	state.mousepressed(g,x,y,button)
end

local function wheelmoved(g,x,y)
	state.wheelmoved(g,x,y)
end

local function gamepadpressed(g,button)
	state.gamepadpressed(g,button)
end

local function draw(g)
	state.draw(g)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	mousepressed = mousepressed,
	wheelmoved = wheelmoved,
	gamepadpressed = gamepadpressed,
	draw = draw,
}