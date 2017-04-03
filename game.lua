local function make(tw,th,gw,gh,sp)
	local g={}--Game object
	g.tile={}
	g.tile.width=tw
	g.tile.height=th
	g.width=gw
	g.height=gh
	g.speed=sp
	g.pause=false

	game.graphics(g,tw,th,gw,gh)
	g.levels=level.load("levels/inis")
	--debugger.printtable(g.levels)

	game.changestate(g,Enums.states.intro)
	return g
end

local function control(g)
	for i,v in ipairs(g.menus) do
		menu.control(v)
	end
	for i,v in ipairs(g.states) do
		state.control(g,v)
	end
	if not g.pause then --TODO figure out why pause is necessary
		g.timer = g.timer + g.speed
	end
end

local function draw(g)
	LG.setCanvas(Canvas.game) --sets drawing to the 320x240 canvas --TODO make canvas part of Game
		LG.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know
		for i,v in ipairs(g.menus) do
			menu.draw(v)
		end
		for i,v in ipairs(g.states) do
			state.draw(g,v)
		end
	LG.setCanvas() --sets drawing back to screen

	screen.control(Screen)
end

local function changestate(g,s)
	local e=Enums
	--initializes game's state, timer, camera, actor, menu and state tables
	g.state=s
	g.timer=0
	g.speed=1
	g.camera=camera.make(0,0)
	g.actors={}
	g.menus={}
	g.states={}
	table.insert(g.states,state.make(s))
	g.counters=counters.init()

	--TODO call specific state's code here? _G style ALSO state a function IN game, so game.state.change, game.state.
	if g.state==e.states.title then
		g.scores=scores.load()
	elseif g.state==e.states.play then
		LG.setCanvas(Canvas.buffer)
		LG.clear()
		g.score=0

		local mw,mh=g.width/g.tile.width,g.height/g.tile.height
		g.map=map.generate(mw+2,mh+2)

		Player=actor.make(EA.character,EA.characters.player,g.width/2,g.height/2)

		g.level=1
		g.levels.current=level.make(g.levels[g.level])
	end
end

local function graphics(g,tw,th,gw,gh)
	--just to declutter load function
	--graphics settings and asset inits
	LG.setDefaultFilter("nearest","nearest",1) --clean SPRITE scaling
	LG.setLineWidth(1)
	LG.setLineStyle("rough") --clean SHAPE scaling
	LG.setBlendMode("alpha")
	love.mouse.setVisible(false)

	--g.font = LG.newFont("fonts/pico8.ttf",8)
	g.font=LG.newFont("fonts/Kongtext Regular.ttf",8)
	g.font:setFilter("nearest","nearest",0) --clean TEXT scaling
	g.font:setLineHeight(1.8)
	LG.setFont(g.font)

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