--game initialization stuff (just boring stuff you need to maek Video Game)
libraries = require("libraries")--have to load the libraries.lua library to use it to dynamically load the rest of the libraries
libraries.load("")--loads all the .lua libraries
Enums = enums.load("","games","modules","flags")--enumerators
enums.constants(Enums)--constants derived from enums, they're shorthand so you can type EM instead of Enums.modules
debugger.printtable(Enums)

love.math.setRandomSeed(os.time())
--love.math.setRandomSeed(1)
Debugger=debugger.make()
love.keyboard.setKeyRepeat(false)
Joysticks={}
SFX = sfx.load(false,true)
Music = music.load()

function love.load()
	Game = game.make(Enums.games.protosnake,Enums.games.modes.topdown,8,8,320,240,1)--TODO this is where load from ini or whatever will happen. or rather, laod from type! g.t=Enums.games.PROTOSNAKE
	--Game = game.make(Enums.games.rpg,Enums.games.modes.roguelike,8,8,320,240,1)
	--debugger.printtable(Game)
end

function love.joystickadded(joystick)
	table.insert(Joysticks,joystick)
end

function love.joystickremoved(joystick)
	local joyid=joystick:getID()
	for i,v in ipairs(Joysticks) do
		if v:getID()==joyid then
			table.remove(Joysticks,i)
		end
	end
end

function love.keypressed(key,scancode,isrepeat)
	game.keypressed(Game,key)

	if key == '`' then
		Debugger.debugging = not Debugger.debugging
	elseif key == 'f' then
		love.window.setFullscreen(not love.window.getFullscreen())
		Screen = screen.update(Game.width,Game.height)
		Debugger.canvas = LG.newCanvas(Screen.width,Screen.height) --sets width and height of debug overlay (size of window)
	end
end

function love.gamepadpressed(joystick,button)
	game.gamepadpressed(Game,button)
end

function love.update(dt)
	game.control(Game)

	debugger.update(Debugger)
end

function love.draw(dt)
	game.draw(Game)

	debugger.draw(Debugger)
end