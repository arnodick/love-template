libraries = require("libraries")
libraries.load()
SFX = sfx.load()

function love.load()
	Game = game.make(8,8,320,240,1)
end

function love.keypressed(key,scancode,isrepeat)
	for i,v in ipairs(Menus) do
		menu.keypressed(v,key)
	end
	if key == 'escape' then
		--TODO going to have to put escape in menu scpecific code like hud etc to make pause menu pop up and go away
		love.event.quit()
	elseif key == '`' then
		DebugMode = not DebugMode
	elseif key == 'f' then
		love.window.setFullscreen(not love.window.getFullscreen())
		Screen = screen.update(Game.width,Game.height)
		Canvas.debug = love.graphics.newCanvas(Screen.width,Screen.height) --sets width and height of debug overlay (size of window)
	end
end

function love.update(dt)
	local gs=Game.speed
	local timerspeed=gs
	if State == Enums.states.game then
		if Pause <= 0 then
			for i,v in ipairs(Actors) do
				actor.control(v,gs)
			end
			camera.control(Camera,Player)
		else
			Pause = Pause - gs
			timerspeed=0
		end
		
		if DebugMode then
			DebugList = debugger.update()
		end
	end
	for i,v in ipairs(Menus) do
		menu.control(v)
	end

	for i,v in ipairs(Actors) do
		if v.delete==true then
			table.remove(Actors,i)
		end
	end

	Timer = Timer + timerspeed
end

function love.draw(dt)
	love.graphics.setCanvas(Canvas.game) --sets drawing to the 320x240 canvas
		love.graphics.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know
		love.graphics.translate(-Camera.x+love.math.random(Camera.shake/2),-Camera.y)
		if State==Enums.states.game then
			for i,v in ipairs(Actors) do
				actor.draw(v)
			end
		end
		for i,v in ipairs(Menus) do
			menu.draw(v)
		end
	love.graphics.setCanvas() --sets drawing back to screen

	love.graphics.origin()
	--love.graphics.setShader(Shader)
	love.graphics.draw(Canvas.game,Screen.xoff,Screen.yoff,0,Screen.scale,Screen.scale) --just like draws everything to the screen or whatever
	--love.graphics.setShader()

	if DebugMode then
		love.graphics.setCanvas(Canvas.debug) --sets drawing to the 1280 x 960 debug canvas
		love.graphics.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know
		debugger.draw(DebugList)
		love.graphics.setCanvas() --sets drawing back to screen
		love.graphics.origin()
		love.graphics.draw(Canvas.debug,0,0,0,1,1) --just like draws everything to the screen or whatever
	end
end