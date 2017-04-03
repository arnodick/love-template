--loads all the .lua libraries
libraries = require("libraries")
libraries.load("")
--enumerators and constants
Enums = enums.load("","actors","levels","states")
debugger.printtable(Enums)
--game initialization stuff (just boring stuff you need to maek Video Game)
--love.math.setRandomSeed(1)
love.math.setRandomSeed(os.time())
Debugger=debugger.make()
love.keyboard.setKeyRepeat(false)
Joysticks=love.joystick.getJoysticks()
SFX = sfx.load(false,true)

function love.load()
	Game = game.make(8,8,320,240,1)--TODO this is where load from ini or whatever will happen. or rather, laod from type! g.t=Enums.games.PROTOSNAKE
end

function love.keypressed(key,scancode,isrepeat)
	for i,v in ipairs(Game.states) do
		state.keypressed(Game,v,key)
	end
	if key == '`' then
		Debugger.debugging = not Debugger.debugging
	elseif key == 'f' then
		love.window.setFullscreen(not love.window.getFullscreen())
		Screen = screen.update(Game.width,Game.height)
		Debugger.canvas = LG.newCanvas(Screen.width,Screen.height) --sets width and height of debug overlay (size of window)
	end
end

function love.gamepadpressed(joystick,button)
	for i,v in ipairs(Game.states) do
		state.gamepadpressed(Game,v,button)
	end
end

function love.update(dt)
	game.control(Game)

	debugger.update(Debugger)
end

function love.draw(dt)
	game.draw(Game)

	debugger.draw(Debugger)
end