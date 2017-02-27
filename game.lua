local function make(tw,th,gw,gh,sp)
--makes game object thing

	--game initialization stuff (just boring stuff you need to maek Video Game)
	--love.math.setRandomSeed(1)
	love.math.setRandomSeed(os.time())
	DebugMode=false
	DebugList={}

	love.keyboard.setKeyRepeat(false)
	Joysticks=love.joystick.getJoysticks()
	SFX = sfx.load(false,true)
	debugger.printtable(SFX,"")

	--enumerators
	Enums = enums.load("","actors","guns","levels")
	--debugger.printtable(Enums,"")

	--global variables
	State,Timer=game.init(Enums.states.intro)--need to use init here so there is State variable to go into changestate below

	game.graphics(tw,th,gw,gh)

	--Game object
	local g={}
	g.tile={}
	g.tile.width=tw
	g.tile.height=th
	g.width=gw
	g.height=gh
	g.speed=sp
	g.settings=game.changestate(State)
	return g
end

local function control(s,gs)
	if s == Enums.states.play then
		Game.settings.counters.enemies=0

		sfx.update(SFX,gs)

		for i,v in ipairs(Actors) do
			actor.control(v,gs)
		end

		camera.control(Camera,Player,gs)
		
		for i,v in ipairs(Actors) do
			if v.delete==true then
				table.remove(Actors,i)
			end
		end

		level.control(Game.settings.levelcurrent)

		if DebugMode then
			DebugList = debugger.update()
		end
	end
	for i,v in ipairs(Huds) do
		hud.control(v)
	end
end

local function draw(s)
	love.graphics.setCanvas(Canvas.game) --sets drawing to the 320x240 canvas
		love.graphics.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know
		if s == Enums.states.play then
			map.draw(Game.settings.map)
			for i,v in ipairs(Actors) do
				actor.draw(v)
			end
		end
		for i,v in ipairs(Huds) do
			hud.draw(v)
		end
	love.graphics.setCanvas() --sets drawing back to screen

	screen.control(Screen)
end

local function init(s)
	--returns the basic game global variables
	--initialize actor and hud tables
	Camera=camera.make(0,0)

	Actors={}
	Huds={}
	return s,0
end

local function changestate(s)
	local e=Enums
	local ea=e.actors
	State,Timer=game.init(s)
	hud.make(s)
	
	local settings={}
	if State==e.states.title then
		settings.scores=scores.load()
	elseif State==e.states.play then
		love.graphics.setCanvas(Canvas.buffer)
		love.graphics.clear()
		settings.score=0
		settings.counters=counters.make()

		local mw,mh=Game.width/Game.tile.width,Game.height/Game.tile.height
		settings.map=map.generate(mw+2,mh+2)

		Player=actor.make(ea.character,ea.characters.player,Game.width/2,Game.height/2)

		settings.level=1
		settings.levelcurrent=level.make(settings.level,Levels)
		--debugger.printtable(settings.levelcurrent,"")
		
--[[
		for a=1,5 do
			actor.make(ea.character,ea.characters.snake)
		end
--]]
	end
	return settings
end

local function graphics(tw,th,gw,gh)
	--just to declutter load function
	--graphics settings and asset inits
	love.graphics.setDefaultFilter("nearest","nearest",1) --clean SPRITE scaling
	love.graphics.setLineWidth(1)
	love.graphics.setLineStyle("rough") --clean SHAPE scaling
	love.graphics.setBlendMode("alpha")
	love.mouse.setVisible(false)

	Font = love.graphics.newFont("fonts/pico8.ttf",8)
	FontDebug = love.graphics.newFont("fonts/lucon.ttf",20)
	Font:setFilter("nearest","nearest",0) --clean TEXT scaling
	Font:setLineHeight(1.1)
	love.graphics.setFont(Font)

	Palettes = palette.load(unpack(love.filesystem.getfiles("palettes","ini")))
	Palette={}
	for a=0,16 do
		Palette[a]=Palettes[Palettes.i][a]
	end

	Spritesheet={}
	Quads={}
	local files = love.filesystem.filterfiles("gfx","png")

	for a=1,#files do
		local ss,qs = sprites.load("gfx/"..files[a],tw*a,th*a)
		table.insert(Spritesheet,ss)
		table.insert(Quads,qs)
	end

	Shader = shader.make()

	Screen = screen.update(gw,gh)

	Canvas = {}
	Canvas.game = love.graphics.newCanvas(gw,gh) --sets width and height of fictional retro video game (320x240)
	Canvas.buffer = love.graphics.newCanvas(gw,gh)
	Canvas.debug = love.graphics.newCanvas(Screen.width,Screen.height) --sets width and height of debug overlay (size of window)
end

return
{
	make = make,
	control = control,
	draw = draw,
	init = init,
	changestate = changestate,
	graphics = graphics,
}