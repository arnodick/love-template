local function make(g)
	--i.imgdata=love.image.newImageData(i.canvas:getWidth()-1,i.canvas:getHeight()-1)
	g.state.font=LG.newFont("fonts/Kongtext Regular.ttf",64)
end


local function control(g)
	if g.timer>=330 then
		game.state.change(g,Enums.states.intro)
	end
end

local function change(g,s)
	g.scores=scores.load()
end

local function keypressed(g,key)
	if key=="space" then
		game.state.change(g,Enums.states.play)
	elseif key=='escape' then
		game.state.change(g,Enums.states.intro)
	end
end

local function gamepadpressed(g,button)
	if button=="start" then
		game.state.change(g,Enums.states.play)
	end
end

local function draw(g)
	local s=g.state
	LG.setCanvas(g.canvas.game)
		LG.setFont(s.font)
		LG.setColor(Palette[EC.dark_purple])
		LG.printf("PROTO\nSNAKE",0,20,Game.width,"center")
		LG.setFont(Game.font)
		LG.setColor(Palette[EC.white])
		LG.printf("PRESS SPACE",0,180,Game.width,"center")
	LG.setCanvas()
	--scores.draw(Game.width/2,Game.height/2,EC.white,EC.yellow)

	local imgdata=g.canvas.game:newImageData(0,0,g.canvas.game:getWidth()-1,g.canvas.game:getHeight()-1)
	imgdata:mapPixel(pixelmaps.sparkle)
	imgdata:mapPixel(pixelmaps.crush)
	local image=LG.newImage(imgdata)
	--s.imgdata:mapPixel(pixelmaps.sparkle)
	love.graphics.draw(image,Screen.xoff,Screen.yoff,0,Screen.scale,Screen.scale,0,0,0,0)
end

return
{
	make = make,
	control = control,
	change = change,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}