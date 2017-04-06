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

	game.state.make(g,Enums.states.intro)
	return g
end

local function control(g)
	for i,v in ipairs(g.menus) do
		menu.control(v)
	end

	game.state.control(g)

	if not g.pause then --TODO figure out why pause is necessary
		g.timer = g.timer + g.speed
	end
end

local function keypressed(g,key,scancode,isrepeat)
	game.state.keypressed(g,key)
end

local function gamepadpressed(g,button)
	game.state.gamepadpressed(g,button)
end

local function draw(g)
	LG.setCanvas(g.canvas.main) --sets drawing to the primary canvas that refreshes every frame
		LG.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know
		for i,v in ipairs(g.menus) do
			menu.draw(v)
		end

		game.state.draw(g)

	LG.setCanvas() --sets drawing back to screen

	screen.control(Screen)
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

	g.canvas = {}
	g.canvas.buffer = LG.newCanvas(gw,gh) --offscreen buffer to draw to, modify, then draw to main canvas
	g.canvas.static = LG.newCanvas(gw,gh) --this canvas doesn't clear every frame, so anything drawn to it stays
	g.canvas.main = LG.newCanvas(gw,gh) --this canvas refreshes every frame, and is where most of the drawing happens
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
	init = init,
	graphics = graphics,
}