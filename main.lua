--game initialization stuff (just boring stuff you need to maek Video Game)
--loads all the .lua libraries
libraries = require("libraries")
libraries.load("")
--enumerators and constants
Enums = enums.load("","actors","levels","states","controllers","menus")
debugger.printtable(Enums)
love.math.setRandomSeed(os.time())
--love.math.setRandomSeed(1)
Debugger=debugger.make()
love.keyboard.setKeyRepeat(false)
Joysticks={}
SFX = sfx.load(false,true)
Music = music.load()

function love.load()
	Game = game.make(8,8,320,240,1)--TODO this is where load from ini or whatever will happen. or rather, laod from type! g.t=Enums.games.PROTOSNAKE
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
--[[
	if Player then
		for i,v in ipairs(Player.controller.types) do
		end
	end
--]]
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