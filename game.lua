local game={}
game.state={}

game.state.run = function(gamename,statename,functionname,...)
	--dynamically runs a function from the current game's current state
	--NOTE need this AND run because this uses a 3D table, maybe some tricky way to lump this in with run?
	local gamestate = _G[gamename][statename]
	if gamestate then
		if gamestate[functionname] then
			return gamestate[functionname](...)
		end
	end
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
	g.player=nil
	g.players={}
	g.level=nil
	g.hud=nil
	g.editor=nil
	g.counters={}
	g.counters.enemy=0
	for i,v in pairs(g.canvas) do
		LG.setCanvas(v)
		LG.clear()
	end
	LG.setCanvas()
--[[
	for i,v in pairs(SFX.sources) do
		v:stop()
	end
--]]
	for i,v in pairs(Music) do
		v:stop()
	end
	screen.update(g)

	hud.make(g)
	game.state.run(g.name,g.state,"make",g)
end

game.player={}
game.player.make = function(g,a,singleplayer)
	if singleplayer then
		g.player=a
	else
		table.insert(g.players,a)
	end
	a.flags=flags.set(a.flags,EF.player,EF.persistent)

	local c="keyboard"
	if g.options then
		if g.options.controller then
			if Joysticks[1] and g.options.controller=="gamepad" then
				c=g.options.controller
			end
		end
	end

	local inputtypesetting=nil
	local gls=g.level.settings
	if gls then
		inputtypesetting=gls.inputtype
	end

	--default to keyboard if no gamepad plugged in
	-- if c=="gamepad" then
	-- 	if not Joysticks[1] then
	-- 		c="keyboard"
	-- 	end
	-- end

	local inputaim=nil
	if gls then
		inputaim=gls.inputaim
	end
	module.make(a,EM.controller,EMC.move,EMCI[c],inputtypesetting)
	if inputaim then
		print("C")
		print(c)
		if c=="keyboard" then
			print("KEYBOARD MOUSE RETICLE")
			module.make(a,EM.controller,EMC.action,EMCI.mouse)
			module.make(a,EM.controller,EMC.aim,EMCI.mouse)
			module.make(a,EM.cursor,"reticle")
		else
			module.make(a,EM.controller,EMC.action,EMCI.gamepad)
			module.make(a,EM.controller,EMC.aim,EMCI.gamepad)
		end
	else
		module.make(a,EM.controller,EMC.action,EMCI[c])
	end

	--TODO reticle if keyboard and mouse and settings for reticle in gls

	game.state.run(g.name,"player","make",g,a)
end

game.player.control = function(g,a)
	game.state.run(g.name,"player","control",g,a)
end

game.player.draw = function(g,a)
	game.state.run(g.name,"player","draw",g,a)
end

game.player.damage = function(g,a)
	game.state.run(g.name,"player","damage",g,a)
end

game.player.dead = function(g,a)
	game.state.run(g.name,"player","dead",g,a)
end

game.make = function(t,gw,gh)
	local g={}
	if type(t)=="string" then
		g.t=Enums.games[t]
		g.name=t
	else
		g.t=t
		g.name=Enums.games[t]
	end
	g.width=gw or 320
	g.height=gh or 240

	g.speed=1
	g.pause=false

	game.graphics(g)

--[[
	g.actordata=supper.load("games/"..g.name.."/actors")
	for i,v in pairs(g.actordata) do
		v.count=0
	end
	supper.print(g.actordata)
--]]
	g.levels=supper.load("games/"..g.name.."/levels")
	-- supper.print(g.levels)
	g.excludes={dawngame="dawngame",offgrid="offgrid",royalewe="royalewe"}

	g.options=json.load("options.json")

--[[
	g.window={}
	g.window.width=g.width
	g.window.height=g.height
--]]

	run(g.name,"make",g)
	game.state.make(g,"intro")

---[[
	if g.window then
		local ww,wh=love.window.getMode()
		if ww~=g.window.width or wh~=g.window.height then
			LG.setCanvas()
			love.window.setMode(g.window.width,g.window.height)
		end
		game.graphics(g)
	end
--]]
	--return g
	Game=g
end

game.control = function(g)
	hud.control(g,g.hud)

	game.state.run(g.name,g.state,"control",g)

	sfx.control(SFX,g.speed)

	if not g.pause then
		for i,v in ipairs(g.actors) do
			if not v.delete then
				-- print(i)
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
			inventory.dead(v,v.inventory)
			game.counters(g,v,-1)
--[[
			if v.name then
				g.actordata[v.name].count=g.actordata[v.name].count-1
			end
--]]
			table.remove(g.actors,i)
			if v.item then
				for k,j in ipairs(g.actors.items) do
					if v==j then
						table.remove(g.actors.items,k)
					end
				end
			end
			if flags.get(v.flags,EF.player) then
				for k,j in ipairs(g.players) do
					if v==j then
						table.remove(g.players,k)
					end
				end
			end
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
	if Debugger.development then
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
	end

	if g.level then
		game.state.run(g.name,"level","keypressed",g,g.level,key)
	end

	if g.state=="intro" then
		if key=="escape" then
			if g.excludes then
				local exc=not g.excludes[g.name]
				print(exc)
				if not g.excludes[g.name] then
					game.make(Enums.games.multigame)
				else
					love.event.quit()
				end
			else
				love.event.quit()
			end
		end
	end

	game.state.run(g.name,g.state,"keypressed",g,key)

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

game.mousemoved = function(g,x,y,dx,dy)
	game.state.run(g.name,g.state,"mousemoved",g,x,y,dx,dy)

	if g.editor then
		cursor.mousemoved(g,g.editor.cursor,x,y,dx,dy)
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
end

game.draw = function(g)
	LG.translate(-g.camera.x+g.width/2,-g.camera.y+g.height/2)
	
	local l=g.level
	if not l or not l.transition or not l.transition.t then
		LG.setCanvas(g.canvas.main) --sets drawing to the primary canvas that refreshes every frame
			LG.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know

			if l then
				if l.drawmodes then
					if l.bgdraw==true then--TODO move this up, should check this earlier
						if l.canvas then
							if l.canvas.background then
								LG.setCanvas(l.canvas.background)
								--LG.clear(190,10,136)
								local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
								LG.translate(xcamoff,ycamoff)

								--TODO this should be l.map.drawmodes?
								map.draw(l.map,l.drawmodes)
								LG.translate(-xcamoff,-ycamoff)
							end
						end
						LG.setCanvas(g.canvas.main)
						l.bgdraw=false
					end
				end
				game.state.run(g.name,"level","draw",g,g.level)
			end

			for i,v in ipairs(g.actors) do
				if not v.delete then
					actor.draw(g,v)
				end
			end

			game.state.run(g.name,g.state,"draw",g)

			if g.editor then
				if g.editor.cursor then
					cursor.draw(g.editor.cursor)
				end
			end
			
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
		run(EM.transitions[l.transition.t],"draw",g,l,l.transition)
	end
	
	LG.origin()

	screen.control(g,g.screen,g.speed)

	-- love.graphics.setShader()
end

game.counters = function(g,a,amount)
	local c=g.counters
	local actorname=EA[a.t]
	if not c[actorname] then
		c[actorname]=0
	end
	c[actorname]=c[actorname]+amount
	if c[actorname]<=0 then
		c[actorname]=nil
	end
	if flags.get(a.flags,EF.enemy) then
		c.enemy=c.enemy+amount
	end
end

--TODO YOU FUCKED THIS UP FIX IT AND PUT GW GH BACK IN DOOFUS
game.graphics = function(g)
	--just to declutter load function
	--graphics settings and asset inits
	LG.setDefaultFilter("nearest","nearest",1) --clean SPRITE scaling
	LG.setLineWidth(1)
	LG.setLineStyle("rough") --clean SHAPE scaling
	LG.setBlendMode("alpha")
	love.mouse.setVisible(true)

	--g.font = LG.newFont("fonts/pico8.ttf",8)
	--g.font=LG.newFont("fonts/Kongtext Regular.ttf",8)
	g.font=LG.newFont("fonts/Kongtext Regular.ttf",8)
	g.font:setFilter("nearest","nearest",0) --clean TEXT scaling
	g.font:setLineHeight(1.8)
	LG.setFont(g.font)

	palette.load(g)
	-- supper.print(g.palette,"PALETTE")

	-- local p={}
	-- supper.copy(p,g.palette)
	-- for k,v in pairs(p) do
	-- 	for i,colourvalue in ipairs(v) do
	-- 		v[i]=math.floor((colourvalue/255)*100)*0.01
	-- 	end
	-- end
	-- supper.print(p,"PALETTE AFTER DIVIDE")
	-- json.save("palette.json",p)

	-- local p2={}
	-- supper.copy(p2,g.palettes[2])
	-- supper.print(p2,"PALETTE 2 BEFORE DIVIDE")
	-- for k,v in pairs(p2) do
	-- 	for i,colourvalue in ipairs(v) do
	-- 		v[i]=math.floor((colourvalue/255)*100)*0.01
	-- 	end
	-- end
	-- json.save("palette2.json",p2)

	--TODO put this in g.?
	Sprites=supper.load("gfx","png")

	Shader = shader.make()
	Shader:send("screenHeight",g.height)

	screen.update(g)

	local gw,gh=g.width,g.height
	g.canvas={}
	g.canvas.buffer=LG.newCanvas(gw,gh) --offscreen buffer to draw to, modify, then draw to main canvas
	g.canvas.background=LG.newCanvas(gw,gh) --this canvas doesn't clear every frame, so anything drawn to it stays, drawn below main canvas
	g.canvas.main=LG.newCanvas(gw,gh) --this canvas refreshes every frame, and is where most of the drawing happens
	g.canvas.hud=LG.newCanvas(gw,gh) --this canvas is for HUD stuff like menus etc.
end

return game