local function make(t,mode,tw,th,gw,gh,sp)
	local g={}--Game object
	g.t=t
	g.name=Enums.games[t]
	g.mode=mode
	g.modename=Enums.games.modes[mode]
	g.tile={}
	g.tile.width=tw
	g.tile.height=th
	g.width=gw
	g.height=gh
	g.speed=sp
	g.pause=false

	game.graphics(g,tw,th,gw,gh)

	if _G[Enums.games[t]]["make"] then
		_G[Enums.games[t]]["make"](g)
	end

	return g
end

local function control(g)

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
	local s=Screen
	LG.translate(-Game.camera.x+(love.math.random(Game.camera.shake/2))*s.scale,-Game.camera.y)

	LG.setCanvas(g.canvas.main) --sets drawing to the primary canvas that refreshes every frame
		LG.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know
		game.state.draw(g)
	LG.setCanvas() --sets drawing back to screen

	LG.origin()

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

	g.palettes = palette.load(unpack(love.filesystem.getfiles("palettes","ini")))
	g.palette={}
	for a=0,16 do
		g.palette[a]=g.palettes[g.palettes.i][a]
	end

	Spritesheet={}
	Quads={}
	local files = love.filesystem.filterfiles("gfx","png")

	tw,th=8,8
	for a=1,#files do
		local ss,qs = sprites.load("gfx/"..files[a],tw*2^(a-1),th*2^(a-1))
		--local ss,qs = sprites.load("gfx/"..files[a],8*2^(a-1),8*2^(a-1))
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