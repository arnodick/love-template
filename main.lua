libraries = require("libraries")
libraries.load()
SFX = sfx.load()

function love.load()
---[[
 	Shader = love.graphics.newShader
	[[
	extern number screenWidth;
	extern number screenHeight;
	vec4 effect(vec4 color,Image texture,vec2 texture_coords,vec2 screen_coords)
	{
		vec2 neigh = texture_coords;
		neigh.x = neigh.x + 1;
		vec4 pixel = Texel(texture, texture_coords);
		vec4 pixel_n = Texel(texture, neigh);
		number xx = floor(texture_coords.x * screenWidth * 4);
		number yy = floor(texture_coords.y * screenHeight * 4);
		number ym = mod(yy,3);


		if (mod(yy,2) == 0)
		{
			pixel.r = pixel.r - 0.5;
			pixel.g = pixel.g - 0.5;
			pixel.b = pixel.b - 0.5;
		}
		return pixel;
    }
 	]]
--]]

	Game = game.make(16,16,320,240)

	--Shader:send("screenWidth", Game.width)
	Shader:send("screenHeight", Game.height)
	
	Screen = screen.update(Game.width,Game.height)

	game.changestate(State)

	--graphics settings and asset inits
	love.graphics.setDefaultFilter("nearest","nearest",1) --clean SPRITE scaling
	love.graphics.setLineWidth(1)
	love.graphics.setLineStyle("rough") --clean SHAPE scaling
	love.graphics.setBlendMode("replace")
	love.mouse.setVisible(false)
	Spritesheet, Quads = sprites.load("gfx/sprites.png", Game.tile.width, Game.tile.height)

	Font = love.graphics.newFont("fonts/pico8.ttf",8)
	FontDebug = love.graphics.newFont("fonts/lucon.ttf",20)
	Font:setFilter("nearest","nearest",0) --clean TEXT scaling
	love.graphics.setFont(Font)

	Canvas = {}
	Canvas.game = love.graphics.newCanvas(Game.width,Game.height) --sets width and height of fictional retro video game (320x240)
	Canvas.debug = love.graphics.newCanvas(Screen.width,Screen.height) --sets width and height of debug overlay (size of window)
end

function love.keypressed(key,scancode,isrepeat)
	love.keyboard.setKeyRepeat(true)
	if State == Enums.states.intro then
		if key=="z" then
			State = State + 1
			game.changestate(State)
		end
	elseif State == Enums.states.title then
		if key=="z" then
			State = State + 1
			game.changestate(State)
		end
	elseif State == Enums.states.options then
		if key=="z" then
			State = State + 1
			game.changestate(State)
		end
	elseif State == Enums.states.game then
		if key=="z" then
			
		end
	end
	if key == 'escape' then
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
	if State == Enums.states.intro then

	elseif State == Enums.states.title then

	elseif State == Enums.states.game then
		if Pause == 0 then
			for i,v in ipairs(Actors) do
				actor.control(v)
			end
		else
			Pause = Pause - 1
		end
		if DebugMode then
			DebugList = debugger.update()
		end
	end
	Timer = Timer + 1
end

function love.draw(dt)
	love.graphics.setCanvas(Canvas.game) --sets drawing to the 320x240 canvas
	love.graphics.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know
	love.graphics.setBlendMode("screen")
	love.graphics.translate(-Camera.x,-Camera.y)
	if State == Enums.states.intro then
		love.graphics.print("intro",160,120)
	elseif State == Enums.states.title then
		love.graphics.print("title",160,120)
	elseif State == Enums.states.options then
		love.graphics.print("options",160,120)
	elseif State == Enums.states.game then
		love.graphics.print("game",160,120)
		for i,v in ipairs(Actors) do
			actor.draw(v)
		end
	end
	love.graphics.setColor(255, 255, 255, 255) --sets draw colour back to normal
	love.graphics.setCanvas() --sets drawing back to screen

	if not DebugMode and State ~= -1 then
		love.graphics.setShader(Shader)
	end
	love.graphics.origin()
	love.graphics.draw(Canvas.game,Screen.xoff,Screen.yoff,0,Screen.scale,Screen.scale,0,0) --just like draws everything to the screen or whatever
	love.graphics.setShader()
	if DebugMode then
		love.graphics.setCanvas(Canvas.debug) --sets drawing to the 1280 x 960 debug canvas
		love.graphics.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know
		--love.graphics.setBackgroundColor(0,0,0,0)
		debugger.draw(DebugList)
		love.graphics.setCanvas() --sets drawing back to screen
		love.graphics.setBlendMode("alpha")
		love.graphics.origin()
		--love.graphics.draw(Canvas.debug,0+Camera.x*Screen.scale+Screen.xoff,0+Camera.y*Screen.scale,0,1,1,0,0) --just like draws everything to the screen or whatever
		love.graphics.draw(Canvas.debug,0,0,0,1,1,0,0) --just like draws everything to the screen or whatever
	end
end