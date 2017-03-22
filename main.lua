--loads all the .lua libraries
libraries = require("libraries")
libraries.load("")
--enumerators and constants
Enums = enums.load("","actors","levels")
--game initialization stuff (just boring stuff you need to maek Video Game)
--love.math.setRandomSeed(1)
love.math.setRandomSeed(os.time())
DebugMode=false
DebugList={}
love.keyboard.setKeyRepeat(false)
Joysticks=love.joystick.getJoysticks()
SFX = sfx.load(false,true)

function love.load()
	Game = game.make(8,8,320,240,1)--TODO this is where load from ini or whatever will happen. or rather, laod from type! g.t=Enums.games.PROTOSNAKE
end

function love.keypressed(key,scancode,isrepeat)
	for i,v in ipairs(Game.huds) do
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
	for i,v in ipairs(Game.huds) do
		hud.gamepadpressed(v,button)
	end
end

function love.update(dt)
	game.control(Game)
end

function love.draw(dt)
	game.draw(Game)

	debugger.draw(DebugList)
end