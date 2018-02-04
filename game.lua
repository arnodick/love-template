local game={}
game.state={}

game.state.run = function(gamename,statename,functionname,...)
	--dynamically runs a function from the current game's current state
	--NOTE need this AND run because this uses a 3D table, maybe some tricky way to lump this in with run?
	--if _G[gamename][statename] then
		if _G[gamename][statename][functionname] then
			_G[gamename][statename][functionname](...)
		end
	--end
end

game.state.make = function(g,state)
	--initializes game's state, timer, camera, actor, menu and state tables
	local e=Enums
	g.state=state

	g.pause=false
	g.timer=0
	g.speed=1
	g.camera=camera.make(g.width/2,g.height/2)
	g.actors={}
	g.players={}
	g.level=nil
	g.hud=nil
	g.editor=nil
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

	hud.make(g)
	game.state.run(g.name,g.state,"make",g)
end

game.make = function(t,tw,th,gw,gh,sp)
	tw = tw or 8
	th = th or 8
	gw = gw or 640
	gh = gh or 480
	sp = sp or 1
	local g={}
	g.t=t
	g.name=Enums.games[t]
	g.tile={}
	g.tile.width=tw
	g.tile.height=th
	g.width=gw
	g.height=gh
	g.speed=sp
	g.pause=false

	--game.graphics(g,tw,th,gw,gh)
	game.graphics(g)

	level.load(g,"games/levels/"..g.name,"json")
	run(g.name,"make",g,tw,th,gw,gh)
	game.state.make(g,"intro")

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
	--return g
	Game = g
end

game.control = function(g)
	if g.hud then
		if g.hud.menu then
			menu.control(g.hud.menu)
		end
	end
	game.state.run(g.name,g.state,"control",g)

	sfx.update(SFX,g.speed)

	if not g.pause then
		for i,v in ipairs(g.actors) do
			if not v.delete then
				actor.control(g,v,g.speed)
			end
		end
	end
	--if g.transition then
	--	transition.control(g,g.transition)
	--end
	camera.control(g.camera,g.speed)
	
	for i,v in ipairs(g.actors) do
		if v.delete==true then
			if v.inventory then
				for j,k in ipairs(v.inventory) do
					k.delete=true
				end
			end
			counters.update(g,g.counters,v,-1)
			table.remove(g.actors,i)
		end
	end

	local l=g.level
	if l then
		game.state.run(g.name,"level","control",g,l)

		if l.transition then
			transition.control(l,l.transition)
		end
	end

	if g.editor then
		editor.control(g)
	end

	if not g.pause then --TODO figure out why pause is necessary
		g.timer = g.timer + g.speed
	end
end

game.keypressed = function(g,key,scancode,isrepeat)
	if key=="tab" then
		if not g.editor then
			g.pause=true
			editor.make(g)
		else
			g.pause=false
			g.editor=nil
		end
	elseif key=="space" then
		palette.set(g,2)
	end

	if g.level then
		game.state.run(g.name,"level","keypressed",g,g.level,key)
	end

	if g.state=="intro" then
		if key=="escape" then
			game.make(Enums.games.multigame)
		end
	end

	--game.state.run(g.name,g.state,"keypressed",g,key)
	supper.run(_G[g.name],{g.state,"keypressed"},g,key)



	if g.editor then
		editor.keypressed(g,key)
	end
end

game.keyreleased = function(g,key)
	if g.level then
		game.state.run(g.name,"level","keyreleased",g,g.level,key)
	end

	game.state.run(g.name,g.state,"keyreleased",g,key)
end

game.mousepressed = function(g,x,y,button)
	game.state.run(g.name,g.state,"mousepressed",g,x,y,button)

	if g.editor then
		editor.mousepressed(g,x,y,button)
	end
end

game.wheelmoved = function(g,x,y)
	game.state.run(g.name,g.state,"wheelmoved",g,x,y)

	if g.editor then
		editor.wheelmoved(g,x,y)
	end
end

game.gamepadpressed = function(g,joystick,button)
	if g.level then
		game.state.run(g.name,"level","gamepadpressed",g,g.level,button)
	end

	game.state.run(g.name,g.state,"gamepadpressed",g,joystick,button)

	if g.hud then
		hud.gamepadpressed(g,joystick,button)
	end
--[[
	if g.editor then
		editor.gamepadpressed(g,button)
	end
--]]
end

game.draw = function(g)
	LG.translate(-g.camera.x+g.width/2,-g.camera.y+g.height/2)
	
	local l=g.level
	if not l or not l.transition or not l.transition.t then
		LG.setCanvas(g.canvas.main) --sets drawing to the primary canvas that refreshes every frame
			LG.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know

			if g.level then
				game.state.run(g.name,"level","draw",g,g.level)
			end

			for i,v in ipairs(g.actors) do
				if not v.delete then
					actor.draw(g,v)
				end
			end

			game.state.run(g.name,g.state,"draw",g)
			
			LG.setCanvas(g.canvas.hud) --sets drawing to hud canvas, which draws OVER everything else
			LG.clear()
			if g.hud then
					--NOTE do this to ahve cursor be affected by pixel effects!
					--LG.setCanvas(g.canvas.hud) --sets drawing to hud canvas, which draws OVER everything else
					--LG.clear()
					hud.draw(g,g.hud)
			end
			if g.editor then
				editor.draw(g)
			end
		LG.setCanvas() --sets drawing back to screen
	else
		if _G[EM.transitions[l.transition.t]]["draw"] then
			_G[EM.transitions[l.transition.t]]["draw"](g,l,l.transition)
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

	palette.load(g,unpack(love.filesystem.getfiles("palettes","ini")))

	--TODO put this in g.?
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