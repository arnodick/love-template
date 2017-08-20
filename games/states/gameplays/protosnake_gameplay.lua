local function make(g)
	module.make(g.state,EM.hud,EM.huds.protosnake_hud)

	g.score=0

	local mw,mh=g.width/g.tile.width,g.height/g.tile.height
	g.map=map.generate(Enums.games.maps.map_2d,mw+2,mh+2)

	g.player=actor.make(EA[Game.name].player,g.width/2,g.height/2)
	--module.make(a,EM.player)

	g.level=1
	g.levels.current=level.make(g,g.level)
end

local function control(g)
	local s=g.state

	if Game.player.hp<=0 then
		if not s.hud.menu then
			module.make(s.hud,EM.menu,EMM.highscores,g.width/2,g.height/2,66,100,"",s.hud.c,s.hud.c2,"center")
		end
	end
end

local function keypressed(g,key)
	if key=='space' then
		if Game.player.hp<=0 then
			game.state.make(g,Enums.games.states.gameplay)
		end
	elseif key=='escape' then
		game.state.make(g,Enums.games.states.title)
	end
end

local function gamepadpressed(g,button)
	if button=="start" then
		if Game.player.hp<=0 then
			game.state.make(g,Enums.games.states.gameplay)
		else
			g.pause = not g.pause
		end
	end

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