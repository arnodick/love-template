local function make(g)
	g.map=map.generate(Enums.games.maps.map_offgrid,10,10)
	g.player={}
	g.player.x=1
	g.player.y=1
	g.level=g.map[g.player.y][g.player.x]
	level.make(g,g.level)
end

local function control(g)

end

local function keypressed(g,key)
	if key=='escape' then
		state.make(g,Enums.games.states.title)
	end
--[[
	elseif key=='z' then
		level.make(g,g.level-1)
	elseif key=='x' then
		level.make(g,g.level+1)
	end
--]]
end

local function gamepadpressed(g,button)
	if button=="a" then
		g.switch = not g.switch
	end
end

local function draw(g)
	if Debugger.debugging then
		--LG.print(g.player.x.." "..g.player.y,10,120)
		--LG.print(g.map[g.player.y][g.player.x],10,130)
		LG.print(g.levels.current.menu.text.index,10,140)
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