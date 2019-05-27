--game initialization stuff (just boring stuff you need to maek Video Game)
library=require("tools/library")--have to load the library.lua library to use it to dynamically load the rest of the libraries
library.load("","lua")--loads all the .lua libraries

Enums=enums.load("","games","actors","modules","modes")--enumerators
enums.constants(Enums)--constants derived from enums, they're shorthand so you can type EM instead of Enums.modules
supper.print(Enums)

love.math.setRandomSeed(os.time())
--love.math.setRandomSeed(1)--for debuggin purposes
Debugger=debugger.make()
love.keyboard.setKeyRepeat(false)
love.keyboard.setTextInput(true)
love.mouse.setRelativeMode(true)--TODO what does this do again?
--TODO should any of the be part of Game?
Joysticks={}
SFX=sfx.load()
Music=music.load()

function love.load()
	game.make("multigame")
	-- game.make("offgrid",640,960)
end

function love.update(dt)
	game.control(Game)

	--TODO only do this if console is on? or better yet, only allow debugger to utrn on if console is on?
	debugger.update(Game,Debugger)
end

function love.keypressed(key,scancode,isrepeat)
	--if not love.keyboard.hasTextInput() then
		local g=Game
		game.keypressed(g,key,scancode,isrepeat)

		if key == '`' then
			Debugger.debugging = not Debugger.debugging
		elseif key == 'f' then
			love.window.setFullscreen(not love.window.getFullscreen())
			screen.update(g)
			Debugger.canvas=LG.newCanvas(g.screen.width,g.screen.height)--sets width and height of debug overlay (size of window)
		end
	--end
end

function love.keyreleased(key)
	game.keyreleased(Game,key)
end

function love.mousepressed(x,y,button)
	game.mousepressed(Game,x,y,button)
end

function love.mousemoved(x,y,dx,dy)
	game.mousemoved(Game,x,y,dx,dy)
end

function love.wheelmoved(x,y)
	game.wheelmoved(Game,x,y)
end

function love.gamepadpressed(joystick,button)
	game.gamepadpressed(Game,joystick,button)
end

function love.joystickadded(joystick)
	table.insert(Joysticks,joystick)
	print("Joystick "..joystick:getID())
	print(" GUID: "..joystick:getGUID())
	print(" Name: "..joystick:getName())
end

function love.joystickremoved(joystick)
	local joyid=joystick:getID()
	for i,v in ipairs(Joysticks) do
		if v:getID()==joyid then
			table.remove(Joysticks,i)
		end
	end
end

function love.draw(dt)
	game.draw(Game)

	debugger.draw(Debugger)
end