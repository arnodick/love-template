local function make(tw,th,gw,gh,sp)
--makes game object thing

	--game initialization stuff (just boring stuff you need to maek Video Game)
	--love.math.setRandomSeed(1)
	love.math.setRandomSeed(os.time())
	DebugMode=false
	DebugList={}
	love.keyboard.setKeyRepeat(false)

	--enumerators
	Enums = LIP.load("ini/enums.ini")

	--global variables
	State,Timer=game.init(3)--need use init here so there is State variable to go into changestate below

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

local function init(s)
	--returns the basic game global variables
	--initialize actor and menu tables
	Camera=camera.make(0,0)

	Joysticks=love.joystick.getJoysticks()
	Joystick=Joysticks[1]

	Actors={}
	Menus={}
	Pause = 0
	return s,0
end

local function changestate(s)
	State,Timer=game.init(s)
	menu.make(s)
	if State==Enums.states.game then
		Player=actor.make(Enums.actors.player,0,160,120)
	end
	local settings={}
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
	Canvas.debug = love.graphics.newCanvas(Screen.width,Screen.height) --sets width and height of debug overlay (size of window)
end

return
{
	make = make,
	init = init,
	changestate = changestate,
	graphics = graphics,
}