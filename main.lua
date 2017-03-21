libraries = require("libraries")
libraries.load("")

function love.load()
	Game = game.make(8,8,320,240,1)
end

function love.keypressed(key,scancode,isrepeat)
	for i,v in ipairs(Huds) do
		hud.keypressed(v,key)
	end
	if key == 'escape' then
		--TODO going to have to put escape in hud specific code like hud etc to make pause hud pop up and go away
		love.event.quit()
	elseif key == '`' then
		DebugMode = not DebugMode
	elseif key == 'f' then
		love.window.setFullscreen(not love.window.getFullscreen())
		Screen = screen.update(Game.width,Game.height)
		Canvas.debug = LG.newCanvas(Screen.width,Screen.height) --sets width and height of debug overlay (size of window)
	end
end

function love.gamepadpressed(joystick,button)
	for i,v in ipairs(Huds) do
		hud.gamepadpressed(v,button)
	end
end

function love.update(dt)
	game.control(Game,State)--TODO: input game into this. State should be part of game? once Game is self-contained, can make different games and switch to them?
end

function love.draw(dt)
	game.draw(Game,State)

	debugger.draw(DebugList)
end