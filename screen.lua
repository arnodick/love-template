local function update(gw,gh)
	local s={}
	s.width,s.height=LG.getDimensions()
	s.scale=math.floor(s.height/gh)
	s.xoff=(s.width-gw*s.scale)/2
	s.yoff=s.height%gh/2
	s.pixelscale=1
	s.pixelscalerateinit=0.1
	s.pixelscalerate=s.pixelscalerateinit
	s.pixelscalemin=0.1
	s.pixeltrans=false
	s.shake=0
	return s
end

local function control(s,gs)
	if s.shake>0 then
		s.shake = s.shake - gs
	end
	local shake=love.math.random(s.shake/2)*s.scale
	if s.pixeltrans then
		local tempcanvas=LG.newCanvas(Game.width*s.pixelscale,Game.height*s.pixelscale)
		LG.setCanvas(tempcanvas)
			LG.draw(Game.canvas.main,0,0,0,s.pixelscale,s.pixelscale)
		LG.setCanvas()

		--LG.setShader(Shader)

		--LG.translate(-Game.camera.x+(love.math.random(Game.camera.shake/2))*s.scale,-Game.camera.y)
		LG.draw(Game.canvas.background,s.xoff+shake,s.yoff,0,s.scale,s.scale)
		LG.draw(tempcanvas,s.xoff+shake,s.yoff,0,s.scale*1/s.pixelscale,s.scale*1/s.pixelscale) --just like draws everything to the screen or whatever
		--LG.origin()
		s.pixelscale=s.pixelscale+s.pixelscalerate*Game.speed
		if s.pixelscalerate<0 then
			if s.pixelscale<=s.pixelscalemin then
				s.pixelscale=s.pixelscalemin
				s.pixelscalerate=s.pixelscalerate*-0.1
			end
		else
			if s.pixelscale>=1 then
				s.pixelscale=1
				s.pixelscalerate=s.pixelscalerateinit
				s.pixeltrans=false
			end
		end
		--LG.setShader()
	else
		--LG.setShader(Shader)
		local g=Game
		--LG.translate(-g.camera.x+(love.math.random(g.camera.shake/2))*s.scale,-g.camera.y)
		LG.draw(g.canvas.background,s.xoff+shake,s.yoff,0,s.scale*g.camera.zoom,s.scale*g.camera.zoom)
		LG.draw(g.canvas.main,s.xoff+shake,s.yoff,0,s.scale*g.camera.zoom,s.scale*g.camera.zoom) --just like draws everything to the screen or whatever
		--LG.origin()
		--LG.setShader()
	end
end

return
{
	update = update,
	control = control,
}