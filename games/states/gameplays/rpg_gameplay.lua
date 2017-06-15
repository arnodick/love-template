local function make(g)
	local mw,mh=g.width/g.tile.width,g.height/g.tile.height
	g.map=map.generate(mw+2,mh+2)

	g.step=false

--[[
	g.level=1
	g.levels.current=level.make(g.level)
--]]

	Player=actor.make(EA[Enums.games[Game.t]].rpg_player,g.width/2,g.height/2)
	actor.make(EA[Enums.games[Game.t]].rpg_enemy,g.width/2,g.height/2)
end

local function control(g)
	--Game.pause=true
end

local function keypressed(g,key)
	if key=='escape' then
		game.state.make(g,Enums.games.states.title)
	end
end

local function gamepadpressed(g,button)

end

local function draw(g)

end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}