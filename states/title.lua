local function make(s)
	s.canvas=LG.newCanvas(640,480)
	--i.imgdata=love.image.newImageData(i.canvas:getWidth()-1,i.canvas:getHeight()-1)
	s.font=LG.newFont("fonts/Kongtext Regular.ttf",64)
end


local function control(g,s)
	if Game.timer>=330 then
		game.state.change(g,Enums.states.intro)
	end
end

local function change(g,s)
	g.scores=scores.load()
end

local function keypressed(g,s,key)
	if key=="space" then
		game.state.change(g,Enums.states.play)
	elseif key=='escape' then
		game.state.change(g,Enums.states.intro)
	end
end

local function gamepadpressed(g,s,button)
	if button=="start" then
		game.state.change(g,Enums.states.play)
	end
end

local function draw(g,s)
	LG.setCanvas(s.canvas)
		LG.setFont(s.font)
		LG.setColor(Palette[EC.dark_purple])
		LG.printf("PROTO\nSNAKE",0,20,Game.width,"center")
		LG.setFont(Game.font)
		LG.setColor(Palette[EC.white])
		LG.printf("PRESS SPACE",0,180,Game.width,"center")
	LG.setCanvas()
	--scores.draw(Game.width/2,Game.height/2,EC.white,EC.yellow)

	local imgdata=s.canvas:newImageData(0,0,s.canvas:getWidth()-1,s.canvas:getHeight()-1)
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