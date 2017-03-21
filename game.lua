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

	--enumerators and constants
	Enums = enums.load("","actors","levels")
	debugger.printtable(Enums)
	constants.init(Enums)

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
	g.pause=false
	game.changestate(g,State)
	Counters=counters.init()
	--debugger.printtable(Counters)
	g.levels=level.load("levels/inis")
	--debugger.printtable(Game.levels)
	return g
end

local function control(g,s)
	if s == Enums.states.play then
		sfx.update(SFX,g.speed)

		if not g.pause then
			for i,v in ipairs(Actors) do
				actor.control(v,g.speed)
			end
		end

		camera.control(Camera,Player,g.speed)
		
		for i,v in ipairs(Actors) do
			if v.delete==true then
				if v.inv then
					v.inv[1].delete=true
				end
				counters.update(Counters,v,-1)
				table.remove(Actors,i)
			end
		end

		level.control(g.levels.current)

		if DebugMode then
			DebugList = debugger.update()
		end
	end
	for i,v in ipairs(Menus) do
		menu.control(v)
	end
	for i,v in ipairs(Huds) do
		hud.control(v)
	end
	if not g.pause then
		Timer = Timer + g.speed
	end
end

local function draw(g,s)
	LG.setCanvas(Canvas.game) --sets drawing to the 320x240 canvas
		LG.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know
		if s == Enums.states.play then
			map.draw(g.settings.map)
			for i,v in ipairs(Actors) do
				actor.draw(v)
			end
		end
		for i,v in ipairs(Menus) do
			menu.draw(v)
		end
		for i,v in ipairs(Huds) do
			hud.draw(v)
		end
	LG.setCanvas() --sets drawing back to screen

	screen.control(Screen)
end

local function init(s)--TODO input Game into this? maybe make it load its values from an ini file
--TODO maybe load instead of init?
	--returns the basic game global variables
	--initialize actor, menu and hud tables
	Camera=camera.make(0,0)
	Actors={}--TODO: maybe all these go into Game.? so: Game.actors Game.menus etc. also Game.camera
	--Game.menus={}
	Menus={}
	Huds={}
	return s,0
end

local function changestate(g,s)
	local e=Enums
	State,Timer=game.init(s)
	hud.make(s)
	Counters=counters.init()
	
	g.settings={}

	if State==e.states.title then
		g.settings.scores=scores.load()
	elseif State==e.states.play then
		LG.setCanvas(Canvas.buffer)
		LG.clear()
		g.settings.score=0

		local mw,mh=g.width/g.tile.width,g.height/g.tile.height
		g.settings.map=map.generate(mw+2,mh+2)

		Player=actor.make(EA.character,EA.characters.player,g.width/2,g.height/2)

		g.settings.level=1
		g.levels.current=level.make(g.levels[g.settings.level])
	end
end

local function graphics(tw,th,gw,gh)
	--just to declutter load function
	--graphics settings and asset inits
	LG.setDefaultFilter("nearest","nearest",1) --clean SPRITE scaling
	LG.setLineWidth(1)
	LG.setLineStyle("rough") --clean SHAPE scaling
	LG.setBlendMode("alpha")
	love.mouse.setVisible(false)

	--Font = LG.newFont("fonts/pico8.ttf",8)
	Font = LG.newFont("fonts/Kongtext Regular.ttf",8)
	FontDebug = LG.newFont("fonts/lucon.ttf",20)
	Font:setFilter("nearest","nearest",0) --clean TEXT scaling
	Font:setLineHeight(1.8)
	LG.setFont(Font)

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
	Canvas.game = LG.newCanvas(gw,gh) --sets width and height of fictional retro video game (320x240)
	Canvas.buffer = LG.newCanvas(gw,gh)
	Canvas.debug = LG.newCanvas(Screen.width,Screen.height) --sets width and height of debug overlay (size of window)
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