local function update(gw,gh)
	local s={}
	s.width,s.height=love.graphics.getDimensions()
	s.scale=math.floor(s.height/gh)
	s.xoff=(s.width-gw*s.scale)/2
	s.yoff=s.height%gh/2
	s.pixelscale=1
	s.pixelscalerate=-0.1
	s.pixelscalemin=0.1
	s.pixeltrans=false
	return s
end

local function control(s)
	if s.pixeltrans then
		local tempcanvas=love.graphics.newCanvas(Game.width*s.pixelscale,Game.height*s.pixelscale)
		love.graphics.setCanvas(tempcanvas)
			love.graphics.draw(Canvas.game,0,0,0,s.pixelscale,s.pixelscale)
		love.graphics.setCanvas()

		--love.graphics.setShader(Shader)

		love.graphics.translate(-Camera.x+(love.math.random(Camera.shake/2))*s.scale,-Camera.y)
		love.graphics.draw(Canvas.buffer,s.xoff,s.yoff,0,s.scale,s.scale)
		love.graphics.draw(tempcanvas,s.xoff,s.yoff,0,s.scale*1/s.pixelscale,s.scale*1/s.pixelscale) --just like draws everything to the screen or whatever
		love.graphics.origin()
		s.pixelscale=s.pixelscale+s.pixelscalerate
		if s.pixelscalerate<0 then
			if s.pixelscale<=s.pixelscalemin then
				s.pixelscale=s.pixelscalemin
				s.pixelscalerate=s.pixelscalerate*-1
			end
		else
			if s.pixelscale>=1 then
				s.pixelscale=1
				s.pixelscalerate=s.pixelscalerate*-1
				s.pixeltrans=false
			end
		end
		--love.graphics.setShader()
	else
		--love.graphics.setShader(Shader)

		love.graphics.translate(-Camera.x+(love.math.random(Camera.shake/2))*s.scale,-Camera.y)
		love.graphics.draw(Canvas.buffer,s.xoff,s.yoff,0,s.scale,s.scale)
		love.graphics.draw(Canvas.game,s.xoff,s.yoff,0,s.scale,s.scale) --just like draws everything to the screen or whatever
		love.graphics.origin()

		--love.graphics.setShader()
	end
end

return
{
	update = update,
	control = control,
}