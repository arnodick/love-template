local function make(t,tw,th,gw,gh,sp)
	local g={}--Game object
	g.t=t
	g.name=Enums.games[t]
	g.tile={}
	g.tile.width=tw
	g.tile.height=th
	g.width=gw
	g.height=gh
	g.speed=sp
	g.pause=false

	game.graphics(g,tw,th,gw,gh)

	if _G[Enums.games[t]]["make"] then
		_G[Enums.games[t]]["make"](g,tw,th,gw,gh)
	end
---[[
	if g.window then
		local ww,wh=love.window.getMode()
		if ww~=g.window.width or wh~=g.window.height then
			LG.setCanvas()
			love.window.setMode(g.window.width,g.window.height)
		end
		game.graphics(g,tw,th,gw,gh)
	end
--]]
	return g
end

local function control(g)
	game.state.control(g)

	if not g.pause then --TODO figure out why pause is necessary
		g.timer = g.timer + g.speed
	end
end

local function keypressed(g,key,scancode,isrepeat)
	if key=="tab" then
		game.state.make(g,Enums.games.states.editor)
	end
	game.state.keypressed(g,key)
end

local function mousepressed(g,x,y,button)
	game.state.mousepressed(g,x,y,button)
end

local function wheelmoved(g,x,y)
	game.state.wheelmoved(g,x,y)
end

local function gamepadpressed(g,button)
	game.state.gamepadpressed(g,button)
end

local function draw(g)
	local s=g.screen
	LG.translate(-g.camera.x+g.width/2,-g.camera.y+g.height/2)

	LG.setCanvas(g.canvas.main) --sets drawing to the primary canvas that refreshes every frame
		LG.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know
		game.state.draw(g)
		if g.state.hud then
			LG.setCanvas(g.canvas.hud) --sets drawing to hud canvas, which draws OVER everything else
				LG.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know
				hud.draw(g,g.state.hud)
				LG.print(love.timer.getFPS(),10,10)
		end
	LG.setCanvas() --sets drawing back to screen
	
	LG.origin()

	screen.control(g,g.screen,g.speed)
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
		table.insert(Spritesheet,ss)
		table.insert(Quads,qs)
	end

	--Shader = shader.make()

	screen.update(g)

	g.canvas = {}
	g.canvas.buffer = LG.newCanvas(gw,gh) --offscreen buffer to draw to, modify, then draw to main canvas
	g.canvas.background = LG.newCanvas(gw,gh) --this canvas doesn't clear every frame, so anything drawn to it stays
	g.canvas.main = LG.newCanvas(gw,gh) --this canvas refreshes every frame, and is where most of the drawing happens
	g.canvas.hud = LG.newCanvas(gw,gh) --this canvas is for HUD stuff like menus etc.
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	mousepressed = mousepressed,
	wheelmoved = wheelmoved,
	gamepadpressed = gamepadpressed,
	draw = draw,
	init = init,
	graphics = graphics,
}