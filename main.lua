--game initialization stuff (just boring stuff you need to maek Video Game)
supper=require("tools/supper")--have to load the supper.lua library to use supper.load to dynamically load the rest of the libraries
--TODO DON'T EXCLUDE PALETTES HERE
Enums=supper.load("","lua",{"images","gfx","fonts","sfx","maps","palettes","music","videos"})--loads all the .lua libraries, returns a table of enums of their functions
enums.constants(Enums)--constants derived from enums, they're shorthand so you can type EM instead of Enums.modules
-- supper.print(Enums,"ENUMS")

love.math.setRandomSeed(os.time())
--love.math.setRandomSeed(1)--for debuggin purposes
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

	--TODO pass this down through game to multigame to make controller on its hud menu rather than here
	local m=g.hud.menu

	--TODO make a function that assigns controllers to player and menus from g.options?
	if g.options then
		m.controller=nil
		module.make(m,EM.controller,EMC.move,EMCI[g.options.controller])
		module.make(m,EM.controller,EMC.action,EMCI[g.options.controller])
	end

	print("Joystick "..joystick:getID())
	print(" GUID: "..joystick:getGUID())
	print(" Name: "..joystick:getName())
	local a,b,c=joystick:getDeviceInfo()
	print(" Info:")
	print("  "..a)
	print("  "..b)
	print("  "..c)

	local p=g.player
	if p then
		p.controller=nil
		module.make(p,EM.controller,EMC.move,EMCI.gamepad)
		module.make(p,EM.controller,EMC.action,EMCI.gamepad)
	end
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