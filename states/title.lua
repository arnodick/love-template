local function make(g)
	g.state.font=LG.newFont("fonts/Kongtext Regular.ttf",64)
	g.scores=scores.load()
	music.play(1)
	g.state.menu=menu.make(EM.interactive,Game.width/2,180,30,30,{"uno","dos"},EC.orange,EC.dark_green,EC.indigo,EC.dark_purple)
end


local function control(g)
	menu.control(g.state.menu)
	if g.timer>=330 then
		game.state.make(g,Enums.states.intro)
	end
end

local function keypressed(g,key)
	if key=="space" then
		game.state.make(g,Enums.states.play)
	elseif key=='escape' then
		game.state.make(g,Enums.states.intro)
	end
end

local function gamepadpressed(g,button)
	if button=="start" then
		game.state.make(g,Enums.states.play)
	end
end

local function draw(g)
	local s=g.state
	LG.setCanvas(g.canvas.buffer)
		LG.setFont(s.font)
		LG.setColor(g.palette[EC.dark_purple])
		LG.printf("PROTO\nSNAKE",0,20,Game.width,"center")
		LG.setFont(Game.font)
		LG.setColor(g.palette[EC.white])
		menu.draw(g.state.menu)
		--LG.printf("PRESS SPACE",0,180,Game.width,"center")
	LG.setCanvas(g.canvas.main)
	--scores.draw(Game.width/2,Game.height/2,EC.white,EC.yellow)
---[[
	local imgdata=g.canvas.buffer:newImageData(0,0,g.canvas.buffer:getWidth()-1,g.canvas.buffer:getHeight()-1)
--	imgdata:mapPixel(pixelmaps.sparkle)
--	imgdata:mapPixel(pixelmaps.crush)
	local image=LG.newImage(imgdata)
	love.graphics.draw(image,0,0,0,1,1,0,0,0,0)
--]]
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}