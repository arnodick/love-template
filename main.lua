libraries = require("libraries")
libraries.load("")

function love.load()
	Game = game.make(8,8,320,240,1)
	Levels=level.load("levels/inis")
	debugger.printtable(Levels)
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
		Canvas.debug = love.graphics.newCanvas(Screen.width,Screen.height) --sets width and height of debug overlay (size of window)
	end
end

function love.update(dt)
	local gs = Game.speed

	game.control(State,gs)

	Timer = Timer + gs
end

function love.draw(dt)
	game.draw(State)

	debugger.draw(DebugList)
end