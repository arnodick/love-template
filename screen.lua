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
	return s
end

local function control(s)
	if s.pixeltrans then
		local tempcanvas=LG.newCanvas(Game.width*s.pixelscale,Game.height*s.pixelscale)
		LG.setCanvas(tempcanvas)
			LG.draw(Canvas.game,0,0,0,s.pixelscale,s.pixelscale)
		LG.setCanvas()

		--LG.setShader(Shader)

		LG.translate(-Game.camera.x+(love.math.random(Game.camera.shake/2))*s.scale,-Game.camera.y)
		LG.draw(Canvas.buffer,s.xoff,s.yoff,0,s.scale,s.scale)
		LG.draw(tempcanvas,s.xoff,s.yoff,0,s.scale*1/s.pixelscale,s.scale*1/s.pixelscale) --just like draws everything to the screen or whatever
		LG.origin()
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

		LG.translate(-Game.camera.x+(love.math.random(Game.camera.shake/2))*s.scale,-Game.camera.y)
		if Game.state==Enums.states.play then
		LG.draw(Canvas.buffer,s.xoff,s.yoff,0,s.scale,s.scale)
		LG.draw(Canvas.game,s.xoff,s.yoff,0,s.scale,s.scale) --just like draws everything to the screen or whatever
		end
		LG.origin()

		--LG.setShader()
	end
end

return
{
	update = update,
	control = control,
}