--game initialization stuff (just boring stuff you need to maek Video Game)
supper=require("tools/supper")--have to load the supper.lua library to use supper.load to dynamically load the rest of the libraries
--TODO DON'T EXCLUDE PALETTES HERE
Enums=supper.load("","lua",{"images","gfx","fonts","sfx","maps","palettes","music","videos"})--loads all the .lua libraries, returns a table of enums of their functions
enums.constants(Enums)--constants derived from enums, they're shorthand so you can type EM instead of Enums.modules
-- supper.print(Enums,"ENUMS")

-- love.math.setRandomSeed(os.time())
love.math.setRandomSeed(1)--for debuggin purposes
Debugger=debugger.make()
love.keyboard.setKeyRepeat(false)
love.keyboard.setTextInput(true)
love.mouse.setRelativeMode(true)--this makes the mouse invisible and makes it so it never reaches the end of the screen TODO maybe make this only come on when playing game with cursor?
--TODO should any of the be part of Game?
Joysticks={}
SFX=sfx.load()
Music=supper.load("music","wav")

-- local http=require("socket.http")
-- local ssl = require("ssl")

function love.load(args)
	game.make("multigame")
	-- supper.print(Game.options)
	-- supper.print(args)
	if supper.contains(args,"development") then
		Debugger.development=true
	end
	-- game.make("policesquad",640,480)

	-- print(love.getVersion())
	-- local b,c,h=http.request("http://www.random.org/integers/?num=10&min=1&max=6&col=1&base=10&format=plain&rnd=new")--this doesn't work bc random.org uses https, so need to use luasec to get from https
	-- print(b)
	-- print(c)
	-- supper.print(h)
end

function love.update(dt)
	local g=Game

	game.control(g)

	screen.control(g,g.screen,g.speed)

	--TODO only do this if console is on? or better yet, only allow debugger to utrn on if console is on?
	debugger.update(g,Debugger)
end

function love.keypressed(key,scancode,isrepeat)
	--if not love.keyboard.hasTextInput() then
		local g=Game
		game.keypressed(g,key,scancode,isrepeat)

		if key == '`' then
			if Debugger.development then
				Debugger.debugging = not Debugger.debugging
			end
		elseif key == 'f' then
			love.window.setFullscreen(not love.window.getFullscreen())
			screen.update(g)
			Debugger.canvas=LG.newCanvas(g.screen.width,g.screen.height)--sets width and height of debug overlay (size of window)
		-- elseif key=='o' then
		-- 	game.control(g)
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
	-- print(button)
end

function love.joystickadded(joystick)
	local g=Game
	table.insert(Joysticks,joystick)

	if g.options then
		if g.options.controller then
			if g.options.controller=="gamepad" then
				local m=g.hud.menu
				if m then
					controller.assign(g,m,g.options,{inputtype="digital"})
				end
				local p=g.player
				if p then
					controller.assign(g,p,g.options,g.level.settings)
				end
			end
		end
	end

	print("Joystick "..joystick:getID())
	print(" GUID: "..joystick:getGUID())
	print(" Name: "..joystick:getName())
	local a,b,c=joystick:getDeviceInfo()
	print(" Info:")
	print("  "..a)
	print("  "..b)
	print("  "..c)

	-- if g.options then
	-- 	if g.options.controller then
	-- 		if Joysticks[1] and g.options.controller=="gamepad" then
	-- 			c=g.options.controller
	-- 		end
	-- 	end
	-- end
end

function love.joystickremoved(joystick)
	local g=Game
	local joyid=joystick:getID()
	for i,v in ipairs(Joysticks) do
		if v:getID()==joyid then
			table.remove(Joysticks,i)
		end
	end
	
	--sets controllers for menus/player back to keyboard if gamepad disconnected
	if g.options then
		if g.options.controller then
			if g.options.controller=="gamepad" then
				local m=g.hud.menu
				if m then
					controller.assign(g,m,{controller="keyboard"},{inputtype="digital"})
				end
				local p=g.player
				if p then
					controller.assign(g,p,{controller="keyboard"},g.level.settings)
				end
			end
		end
	end
end

function love.draw(dt)
	local g=Game

	game.draw(g)

	screen.draw(g,g.screen,g.speed)

	debugger.draw(g,Debugger)
end