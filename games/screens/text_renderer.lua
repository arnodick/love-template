local function control(g,s,...)
	local shake=love.math.random(-s.shake/4,s.shake/4)*s.scale

	LG.setCanvas(g.canvas.buffer)
		LG.draw(g.canvas.window,0,0,0,g.bufferscale,g.bufferscale)
	LG.setCanvas()

	local imgdata=g.canvas.buffer:newImageData(0,0,g.canvas.buffer:getWidth(),g.canvas.buffer:getHeight())
--[[
	if g.cursor then
		local r,g,b,a=imgdata:getPixel(g.cursor.x,g.cursor.y)
		local t=r.." "..g.." "..b.." "..a
		LG.print(t,0,0)
		local l=LG.lightness(r,g,b)
		l=l*10
		l=math.ceil(l)
		LG.print(l,0,10)
	end
--]]
	if g.switch then
		LG.setCanvas(g.canvas.window)
		LG.clear()
		for y=0,imgdata:getWidth()-1 do
			for x=0,imgdata:getHeight()-1 do
				local r,gr,b=imgdata:getPixel(x,y)
				local l=LG.lightness(r,gr,b)
				l=math.ceil(l*10)
				LG.setColor(r,gr,b)
				LG.print(g.chars[l+1],x*g.tile.width,y*g.tile.height)
			end
		end
		LG.setColor(g.palette[16]) --sets draw colour back to normal
	end

	LG.setCanvas(g.canvas.main)
		LG.draw(g.canvas.window,0,0,0,1,1)
		if g.menu then
			menu.draw(g.menu)
		end
	LG.setCanvas()
	LG.draw(g.canvas.main,(g.width*s.scale/2)+s.xoff+shake,(g.height*s.scale/2)+s.yoff,0,s.scale*g.camera.zoom,s.scale*g.camera.zoom,g.width/2,g.height/2) --just like draws everything to the screen or whatever

--[[
	local tempcanvas=LG.newCanvas(g.width*s.pixelscale,g.height*s.pixelscale)
	LG.setCanvas(tempcanvas)
		LG.draw(g.canvas.background,0,0,0,s.pixelscale,s.pixelscale)
		LG.draw(g.canvas.main,0,0,0,s.pixelscale,s.pixelscale)
	LG.setCanvas()

	LG.draw(tempcanvas,s.xoff+shake,s.yoff,0,s.scale*1/s.pixelscale,s.scale*1/s.pixelscale) --just like draws everything to the screen or whatever
	LG.draw(g.canvas.hud,(g.width*s.scale/2)+s.xoff,(g.height*s.scale/2)+s.yoff,0,s.scale*g.camera.zoom,s.scale*g.camera.zoom,g.width/2,g.height/2) --just like draws everything to the screen or whatever

	if s.transition then
		transition.control(s,s.transition)
	end
	s.pixelscale=math.clamp(s.pixelscale,0.1,1)
--]]
end

return
{
	control = control,
}