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
		game.state.make(g,Enums.games.states.title)
	elseif key=='z' then
		level.make(g,g.level-1)
	elseif key=='x' then
		level.make(g,g.level+1)
	end
end

local function gamepadpressed(g,button)
	if button=="a" then
		g.switch = not g.switch
	end
end

local function draw(g)
	local images=g.images[g.level]
	local animspeed=10
	if g.levels.current.animspeed then
		animspeed=g.levels.current.animspeed
	end
	local anim=math.floor((g.timer/animspeed)%#images)
	LG.draw(images[1+anim],0,0)
	if g.menu then
		menu.draw(g.menu)
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