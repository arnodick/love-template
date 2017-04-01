local function make(t)
	t.canvas=LG.newCanvas(640,480)
	--i.imgdata=love.image.newImageData(i.canvas:getWidth()-1,i.canvas:getHeight()-1)
	t.font=LG.newFont("fonts/Kongtext Regular.ttf",64)
end


local function control(t)
	if Game.timer>=330 then
		game.changestate(Game,Enums.states.intro)
	end
end

local function keypressed(t,key)
	if key=="space" then
		game.changestate(Game,Enums.states.play)
	elseif key=='escape' then
		--TODO going to have to put escape in hud specific code like hud etc to make pause hud pop up and go away
		game.changestate(Game,Enums.states.intro)
	end
end

local function gamepadpressed(i,button)
	if button=="start" then
		game.changestate(Game,Enums.states.play)
	end
end

local function draw(t)
	LG.setCanvas(t.canvas)
		LG.setFont(t.font)
		LG.setColor(Palette[EC.dark_purple])
		LG.printf("PROTO\nSNAKE",0,20,Game.width,"center")
		LG.setFont(Game.font)
		LG.setColor(Palette[EC.white])
		LG.printf("PRESS SPACE",0,180,Game.width,"center")
	LG.setCanvas()
	--scores.draw(Game.width/2,Game.height/2,EC.white,EC.yellow)

	local imgdata=t.canvas:newImageData(0,0,t.canvas:getWidth()-1,t.canvas:getHeight()-1)
	imgdata:mapPixel(pixelmaps.sparkle)
	imgdata:mapPixel(pixelmaps.crush)
	local image=LG.newImage(imgdata)
	--t.imgdata:mapPixel(pixelmaps.sparkle)
	love.graphics.draw(image,Screen.xoff,Screen.yoff,0,Screen.scale,Screen.scale,0,0,0,0)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}