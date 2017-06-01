local function make(g)
	module.make(g.state,EM.hud,EM.huds.protosnake_hud)

	g.score=0

	local mw,mh=g.width/g.tile.width,g.height/g.tile.height
	g.map=map.generate(mw+2,mh+2)

	Player=actor.make(EA.player,g.width/2,g.height/2)

	g.level=1
	g.levels.current=level.make(g.level)
end

local function control(g)
	local s=g.state
	if Player.hp<=0 then
		if not s.hud.menu then
			module.make(s.hud,EM.menu,EMM.highscores,g.width/2,g.height/2,66,100,"",s.hud.c,s.hud.c2,"center")
		end
	end
end

local function keypressed(g,key)
	if key=='space' then
		if Player.hp<=0 then
			game.state.make(g,Enums.states.gameplay)
		--[[
		else
			Screen.pixeltrans=true
			if g.camera.zoom==1 then
				g.camera.zoom=2
			else
				g.camera.zoom=1
			end
		
			g.levels.current=level.make("store")
		--]]
		end
	elseif key=='escape' then
		game.state.make(g,Enums.states.title)
	end
end

local function gamepadpressed(g,button)
	if button=="start" then
		if Player.hp<=0 then
			game.state.make(g,Enums.states.gameplay)
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