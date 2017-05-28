local function make(g)
	module.make(g.state,Enums.modules.hud,Enums.modules.huds.protosnake_hud)
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
	local s=g.state

	map.draw(g.map)
	for i,v in ipairs(g.actors) do
		if not v.delete then
			actor.draw(v)
		end
	end

	if s.hud then
		hud.draw(s.hud)
	end

	if g.pause then
		LG.printformat("PAUSE",g.camera.x+140,g.camera.y+g.height/2,g.width,"left",EC.white,s.c)
	end

	if Player.hp <= 0 then
		LG.printformat("YOU DIED",0,g.height/2-66,g.width,"center",EC.white,s.c)
		LG.printformat("PRESS SPACE",0,g.height/2+60,g.width,"center",EC.white,s.c)
		menu.draw(s.menu)
	end

	LG.setColor(g.palette[EC.pure_white])
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}