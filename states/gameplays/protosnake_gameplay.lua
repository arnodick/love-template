local function make(g)
	g.state.c=EC.orange
	g.state.c2=EC.dark_green
	--g.state.c=love.math.random(#g.palette)
	--g.state.c2=love.math.random(#g.palette)
	g.state.score={}
	g.state.score.x=12
	g.state.score.y=6
	g.state.coins={}
	g.state.coins.x=120
	g.state.coins.y=6
	g.state.hp={}
	g.state.hp.x=240
	g.state.hp.y=6

	g.score=0

	local mw,mh=g.width/g.tile.width,g.height/g.tile.height
	g.map=map.generate(mw+2,mh+2)

	Player=actor.make(EA.player,g.width/2,g.height/2)

	g.level=1
	g.levels.current=level.make(g.level)
end

local function control(g)

end

local function keypressed(g,key)

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