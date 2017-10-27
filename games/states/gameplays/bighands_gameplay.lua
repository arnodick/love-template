local function make(g)
	local mw,mh=g.width/g.tile.width,g.height/g.tile.height
	g.map=map.generate("walls",mw+2,mh+2)
	g.player=actor.make(EA[Game.name].bighands_player,g.width/2,g.height/2)
end

local function control(g)
	
end

local function keypressed(g,key)
	if key=='escape' then
		game.state.make(g,"title")
	end
end

local function gamepadpressed(g,button)
	if button=="start" then
		g.pause = not g.pause
	end

end

local function draw(g)
	LG.print("bighands gaem", g.width/2, g.height/2)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}