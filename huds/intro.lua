local function make(i)
	i.canvas=LG.newCanvas(640,480)

end

local function control()

end

local function keypressed(i,key)
	if key=="space" then
		game.changestate(Game,Enums.states.title)
	end
end

local function gamepadpressed(i,button)
	if button=="start" then
		game.changestate(Game,Enums.states.title)
	end
end

local function draw(i)
	LG.setCanvas(i.canvas)
		LG.clear()
		--LG.setColor(Palette[EC.blue])
		--LG.rectangle("fill",0,0,640,480)
		LG.setColor(Palette[EC.white])
		LG.print("INTRO\nBLAHBLAHBLAH",Game.width/2,Game.height-Game.timer)
	LG.setCanvas()

	local cw,ch=i.canvas:getWidth(),i.canvas:getHeight()
	local imgdata=i.canvas:newImageData(0,0,cw-1,ch-1)
	local iw,ih=imgdata:getWidth(),imgdata:getHeight()
	local mid=iw/2
	
	for x = iw-1,0,-1 do
		local xoff=math.floor(x-mid)
	    for y = ih-1,0,-1  do
			local ynorm=y/ih
			local xoffsquish=xoff*ynorm
			local xsquish=math.clamp(xoffsquish+mid,0,iw)
			local r,g,b,a = imgdata:getPixel(x,y)
			--imgdata:setPixel(math.min(x+10,imgdata:getWidth()-1),y,r,g,b,a)
			--imgdata:setPixel(math.min(xsquish,iw-1),y,r,g,b,a)
			--imgdata:setPixel(xsquish,imgdata:getWidth()-1,y,r,g,b,a)
			imgdata:setPixel(xsquish,y,r,g,b,a)
	    end
	end
	local image=LG.newImage(imgdata)
	--love.graphics.draw(i.canvas,Screen.xoff,Screen.yoff,0,Screen.scale,Screen.scale,0,0,0,0)
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