local game={}

--[[
game.state={}

state.make = function(g,t,mode,st)
	--initializes game's state, timer, camera, actor, menu and state tables
	local e=Enums
	g.state={}
	g.state.t=t
	g.state.mode=mode
	g.state.modename=Enums.games.modes[mode]
	if st then
		g.state.st=st
	else
		local statename=Enums.games.states[t]
		local gamename=Enums.games[g.t]
		g.state.st=Enums.games.states[statename.."s"][gamename.."_"..statename]
	end
	g.timer=0
	g.speed=1
	g.camera=camera.make(g.width/2,g.height/2)
	g.actors={}
	g.counters=counters.init(g.t)
	for i,v in pairs(g.canvas) do
		LG.setCanvas(v)
		LG.clear()
	end
	for i,v in pairs(SFX.sources) do
		v:stop()
	end
	for i,v in pairs(Music.sources) do
		v:stop()
	end
	screen.update(g)
	run(e.games.states[g.state.t],"make",g)
end
--]]

game.make = function(t,tw,th,gw,gh,sp)
	local g={}--Game object
	g.t=t
	g.name=Enums.games[t]
	g.tile={}
	g.tile.width=tw
	g.tile.height=th
	g.width=gw
	g.height=gh
	g.speed=sp
	g.pause=false

	game.graphics(g,tw,th,gw,gh)

	run(g.name,"make",g,tw,th,gw,gh)
	state.make(g,Enums.games.states.intro)

---[[
	if g.window then
		local ww,wh=love.window.getMode()
		if ww~=g.window.width or wh~=g.window.height then
			LG.setCanvas()
			love.window.setMode(g.window.width,g.window.height)
		end
		game.graphics(g,tw,th,gw,gh)
	end
--]]
	return g
end

game.control = function(g,s)
	run(Enums.games.states[s.t],"control",g)

	if g.editor then
		editor.control(g)
	end

	if not g.pause then --TODO figure out why pause is necessary
		g.timer = g.timer + g.speed
	end
end

game.keypressed = function(g,s,key,scancode,isrepeat)
	if key=="tab" then
		state.make(g,Enums.games.states.editor)
	end

	run(Enums.games.states[s.t],"keypressed",g,key)

	if g.editor then
		editor.keypressed(g,key)
	end
end

game.keyreleased = function(g,s,key)
	run(Enums.games.states[s.t],"keyreleased",g,key)
end

game.mousepressed = function(g,s,x,y,button)
	run(Enums.games.states[s.t],"mousepressed",g,x,y,button)

	if g.editor then
		editor.mousepressed(g,x,y,button)
	end
end

game.wheelmoved = function(g,s,x,y)
	run(Enums.games.states[s.t],"wheelmoved",g,x,y)

	if g.editor then
		editor.wheelmoved(g,x,y)
	end
end

game.gamepadpressed = function(g,s,button)
	run(Enums.games.states[s.t],"gamepadpressed",g,button)

	if g.editor then
		editor.gamepadpressed(g,button)
	end
end

game.draw = function(g,s)
	LG.translate(-g.camera.x+g.width/2,-g.camera.y+g.height/2)

	local glc=nil
	if g.levels then
		glc = g.levels.current
	end
	if not glc or not glc.transition or not glc.transition.t then
		LG.setCanvas(g.canvas.main) --sets drawing to the primary canvas that refreshes every frame
			LG.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know

			run(Enums.games.states[s.t],"draw",g)
			
			if g.editor then
				editor.draw(g)
			end

			if g.state.hud then
				LG.setCanvas(g.canvas.hud) --sets drawing to hud canvas, which draws OVER everything else
					LG.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know
					hud.draw(g,g.state.hud)
					LG.print(love.timer.getFPS(),10,10)
			end
		LG.setCanvas() --sets drawing back to screen
	else
		if _G[EM.transitions[glc.transition.t]]["draw"] then
			_G[EM.transitions[glc.transition.t]]["draw"](g,glc,glc.transition)
		end
	end
	
	LG.origin()

	screen.control(g,g.screen,g.speed)
end

game.graphics = function(g,tw,th,gw,gh)
	--just to declutter load function
	--graphics settings and asset inits
	LG.setDefaultFilter("nearest","nearest",1) --clean SPRITE scaling
	LG.setLineWidth(1)
	LG.setLineStyle("rough") --clean SHAPE scaling
	LG.setBlendMode("alpha")
	love.mouse.setVisible(false)

	--g.font = LG.newFont("fonts/pico8.ttf",8)
	g.font=LG.newFont("fonts/Kongtext Regular.ttf",8)
	g.font:setFilter("nearest","nearest",0) --clean TEXT scaling
	g.font:setLineHeight(1.8)
	LG.setFont(g.font)

	g.palettes = palette.load(unpack(love.filesystem.getfiles("palettes","ini")))
	g.palette={}
	for a=0,16 do
		g.palette[a]=g.palettes[g.palettes.i][a]
	end

	Spritesheet={}
	Quads={}
	local files = love.filesystem.filterfiles("gfx","png")

	tw,th=8,8
	for a=1,#files do
		local ss,qs = sprites.load("gfx/"..files[a],tw*2^(a-1),th*2^(a-1))
		table.insert(Spritesheet,ss)
		table.insert(Quads,qs)
	end

	--Shader = shader.make()

	screen.update(g)

	g.canvas = {}
	g.canvas.buffer = LG.newCanvas(gw,gh) --offscreen buffer to draw to, modify, then draw to main canvas
	g.canvas.background = LG.newCanvas(gw,gh) --this canvas doesn't clear every frame, so anything drawn to it stays
	g.canvas.main = LG.newCanvas(gw,gh) --this canvas refreshes every frame, and is where most of the drawing happens
	g.canvas.hud = LG.newCanvas(gw,gh) --this canvas is for HUD stuff like menus etc.
end

return game