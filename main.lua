libraries = require("libraries")
libraries.load("")

function love.load()
	Game = game.make(8,8,320,240,1)

	local ea=Enums.actors
	local leveldata={}
	local level1={}
	level1.t=Enums.levels.arena
	level1.enemies={ea.characters.snake,ea.characters.mushroom,ea.characters.snake,ea.characters.snake,ea.characters.snake,ea.characters.snake,ea.characters.snake,ea.characters.snake,ea.characters.snake,ea.characters.snake}
	level1.enemies.max=5
	level1.c={32,51,123,120}
	table.insert(leveldata,level1)

	local level2={}
	level2.t=Enums.levels.arena
	level2.enemies={ea.characters.snake}
	level2.enemies.max=1
	level2.c={0,144,61}
	table.insert(leveldata,level1)

	local store={}
	store.t=Enums.levels.store
	store.enemies={ea.characters.mushroom}
	store.enemies.max=1
	store.c={247,15,2,120}

	leveldata.store=store

	Levels = leveldata--TODO load from ini here?
	debugger.printtable(Levels,"")

	--local testlevel=LIP.load("ini/level1.ini")
	--debugger.printtable(testlevel,"")
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