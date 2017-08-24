local function update(gw,gh)
	local s={}
	s.width,s.height=LG.getDimensions()
	s.scale=math.floor(s.height/gh)
	s.xoff=(s.width-gw*s.scale)/2
	s.yoff=s.height%gh/2
--[[
	if s.width>=s.height then
		s.scale=math.floor(s.height/gh)
		s.xoff=(s.width-gw*s.scale)/2
		s.yoff=s.height%gh/2
	else
		s.scale=math.floor(s.width/gw)
		s.xoff=(s.height-gh*s.scale)/2
		s.yoff=s.width%gw/2
	end
--]]
	s.pixelscale=1
	s.shake=0
	return s
end

local function control(s,gs)
	local g=Game
	if s.shake>0 then
		s.shake = s.shake - gs
	end

	local shake=love.math.random(-s.shake/4,s.shake/4)*s.scale

	if g.t==Enums.games.protosnake then
		if s.transition then
			local tempcanvas=LG.newCanvas(g.width*s.pixelscale,g.height*s.pixelscale)
			LG.setCanvas(tempcanvas)
				LG.draw(g.canvas.background,0,0,0,s.pixelscale,s.pixelscale)
				LG.draw(g.canvas.main,0,0,0,s.pixelscale,s.pixelscale)
			LG.setCanvas()

			--LG.setShader(Shader)

			LG.draw(tempcanvas,s.xoff+shake,s.yoff,0,s.scale*1/s.pixelscale,s.scale*1/s.pixelscale) --just like draws everything to the screen or whatever
			LG.draw(g.canvas.hud,(g.width*s.scale/2)+s.xoff,(g.height*s.scale/2)+s.yoff,0,s.scale*g.camera.zoom,s.scale*g.camera.zoom,g.width/2,g.height/2) --just like draws everything to the screen or whatever

			transition.control(s,s.transition)
			s.pixelscale=math.clamp(s.pixelscale,0.1,1)

			--LG.setShader()
		else
			--LG.setShader(Shader)
			local g=Game
			LG.draw(g.canvas.background,(g.width*s.scale/2)+s.xoff+shake,(g.height*s.scale/2)+s.yoff,0,s.scale*g.camera.zoom,s.scale*g.camera.zoom,g.width/2,g.height/2)
			LG.draw(g.canvas.main,(g.width*s.scale/2)+s.xoff+shake,(g.height*s.scale/2)+s.yoff,0,s.scale*g.camera.zoom,s.scale*g.camera.zoom,g.width/2,g.height/2) --just like draws everything to the screen or whatever
			LG.draw(g.canvas.hud,(g.width*s.scale/2)+s.xoff,(g.height*s.scale/2)+s.yoff,0,s.scale*g.camera.zoom,s.scale*g.camera.zoom,g.width/2,g.height/2) --just like draws everything to the screen or whatever
			--LG.setShader()
		end
	elseif g.t==Enums.games.text then
		local tempcanvas=LG.newCanvas(g.width*s.pixelscale,g.height*s.pixelscale)
		LG.setCanvas(tempcanvas)
			LG.draw(g.canvas.background,0,0,0,s.pixelscale,s.pixelscale)
			LG.draw(g.canvas.main,0,0,0,s.pixelscale,s.pixelscale)
		LG.setCanvas()

		--LG.setShader(Shader)

		LG.draw(tempcanvas,s.xoff+shake,s.yoff,0,s.scale*1/s.pixelscale,s.scale*1/s.pixelscale) --just like draws everything to the screen or whatever
		LG.draw(g.canvas.hud,(g.width*s.scale/2)+s.xoff,(g.height*s.scale/2)+s.yoff,0,s.scale*g.camera.zoom,s.scale*g.camera.zoom,g.width/2,g.height/2) --just like draws everything to the screen or whatever

		if s.transition then
			transition.control(s,s.transition)
		end
		s.pixelscale=math.clamp(s.pixelscale,0.1,1)
	end
end

return
{
	update = update,
	control = control,
}