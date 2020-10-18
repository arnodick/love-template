local screen={}

--TODO figure out what is going on in here, comment it
screen.update = function(g)
	local s={}
	local gw,gh=g.width,g.height--height and width in pixels of the game (usually 320x240)
	s.width,s.height=LG.getDimensions()--gets the width and height of the window (NOT the game or screen) when game toggles between fullscreen screen.update is run again to get new dimensions
	--TODO right now this only scales up based on the height of the game and screen, so for some game/window dimensions it will be weird
	s.scale=math.floor(s.height/gh)--scales up the game's canvas(?) so that it takes up as much space as possible in the window
	s.xoff=(s.width-gw*s.scale)/2--horizontally centres the screen's canvas(?) so when the window is larger than the game's dimensions (setting it to 0 will put the game's display at the left side of the window)
	s.yoff=s.height%gh/2--same as xoff, but for vertical centre
	s.draw={}
	--TODO s.draw.x=(g.width*s.scale/2)+s.xoff+shake
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
	s.pixelscale=1--this is used when doing pixelated transitions
	s.shake=0

	s.font=LG.newFont("fonts/Kongtext Regular.ttf",8)
	--LG.setFont(s.font)


	s.canvas=LG.newCanvas(gw,gh)--the screen's canvas is the size of the game's dimensions (usually 320x240)
	s.drawcanvas=s.canvas
	-- s.canvas=LG.newCanvas(s.width,s.height)
	s.clear=true--this seems to be unused currently, but will set the screen's canvas to be cleared when no screen transition is happening
	g.screen=s
	if Shader then
		Shader:send("screenScale",s.scale)
	end
end

screen.control = function(g,s,gs)
	--TODO put all calculations in here so they aren't happening in draw function
	if s.shake>0 then
		s.shake=s.shake-gs
	end
	if s.transition then
		transition.control(s,s.transition)
		s.pixelscale=math.clamp(s.pixelscale,0.1,1)
		s.drawcanvas=LG.newCanvas(g.width*s.pixelscale,g.height*s.pixelscale)
	else
		if s.drawcanvas~=s.canvas then
			s.drawcanvas=s.canvas
		end
	end
end

screen.draw = function(g,s,gs)
	--TODO put these locals into s.draw
	local shake=love.math.random(-s.shake/4,s.shake/4)*s.scale

	local x=(g.width*s.scale/2)+s.xoff+shake
	local y=(g.height*s.scale/2)+s.yoff
	local scale=(s.scale/s.pixelscale)*g.camera.zoom

	LG.setCanvas(s.drawcanvas)--everything(?) is drawn to the screen's canvas, which is the height and width of the game (usually 320x240)
		--local t=math.floor(g.timer/gs)%2 --this makes the game draw half as often, making it fake 30fps
		--if t==0 then
		if s.clear==true then
			LG.clear()
		end
		if g.level then
			if g.level.canvas then
				LG.draw(g.level.canvas.background,-g.camera.x*s.pixelscale,-g.camera.y*s.pixelscale,0,s.pixelscale,s.pixelscale,-g.width/2,-g.height/2)
				-- LG.draw(g.level.canvas.background,-g.camera.x,-g.camera.y,0,1,1,-g.width/2,-g.height/2)
			end
		end
		LG.draw(g.canvas.main,0,0,0,s.pixelscale,s.pixelscale)
		--end
	LG.setCanvas()
	if Shader then
		love.graphics.setShader(Shader)
		LG.draw(s.drawcanvas,x,y,0,scale,scale,g.width/2*s.pixelscale,g.height/2*s.pixelscale)
		love.graphics.setShader()
	else
		LG.draw(s.drawcanvas,x,y,0,scale,scale,g.width/2*s.pixelscale,g.height/2*s.pixelscale)
	end

-- 	if s.transition then
		
-- 		local tempcanvas=LG.newCanvas(g.width*s.pixelscale,g.height*s.pixelscale)
-- 		LG.setCanvas(tempcanvas)
-- 			if g.level then
-- 				if g.level.canvas then
-- 					LG.draw(g.level.canvas.background,-g.camera.x*s.pixelscale,-g.camera.y*s.pixelscale,0,s.pixelscale,s.pixelscale,-g.width/2,-g.height/2)
-- 				end
-- 			end
-- 			LG.draw(g.canvas.main,0,0,0,s.pixelscale,s.pixelscale)
-- 		LG.setCanvas()
		
-- 		LG.draw(tempcanvas,x,y,0,scale,scale,g.width/2*s.pixelscale,g.height/2*s.pixelscale) --just like draws everything to the screen or whatever

-- 		-- transition.control(s,s.transition)
-- 		-- s.pixelscale=math.clamp(s.pixelscale,0.1,1)
-- 	else
-- 		LG.setCanvas(s.drawcanvas)--everything(?) is drawn to the screen's canvas, which is the height and width of the game (usually 320x240)
-- 			--local t=math.floor(g.timer/gs)%2 --this makes the game draw half as often, making it fake 30fps
-- 			--if t==0 then
-- 			if s.clear==true then
-- 				LG.clear()
-- 			end
-- 			if g.level then
-- 				if g.level.canvas then
-- 					LG.draw(g.level.canvas.background,-g.camera.x*s.pixelscale,-g.camera.y*s.pixelscale,0,s.pixelscale,s.pixelscale,-g.width/2,-g.height/2)
-- 					-- LG.draw(g.level.canvas.background,-g.camera.x,-g.camera.y,0,1,1,-g.width/2,-g.height/2)
-- 				end
-- 			end
-- 			LG.draw(g.canvas.main,0,0,0,s.pixelscale,s.pixelscale)
-- 			--end
-- 		LG.setCanvas()
-- 		if Shader then
-- 			love.graphics.setShader(Shader)
-- 			LG.draw(s.drawcanvas,x,y,0,scale,scale,g.width/2*s.pixelscale,g.height/2*s.pixelscale)
-- 			love.graphics.setShader()
-- 		else
-- 			LG.draw(s.drawcanvas,x,y,0,scale,scale,g.width/2*s.pixelscale,g.height/2*s.pixelscale)
-- 		end
-- --[[
-- 		LG.draw(g.canvas.background,x,y,0,scale,scale,g.camera.x,g.camera.y)
-- 		if g.level then
-- 			if g.level.canvas then
-- 				LG.draw(g.level.canvas.background,x,y,0,scale,scale,g.camera.x,g.camera.y)
-- 			end
-- 		end
-- 		LG.draw(g.canvas.main,      x,y,0,scale,scale,g.width/2,g.height/2) --just like draws everything to the screen or whatever
-- --]]
-- 	end
	LG.draw(g.canvas.hud,(g.width*s.scale/2)+s.xoff,(g.height*s.scale/2)+s.yoff,0,s.scale,s.scale,g.width/2,g.height/2) --just like draws everything to the hud or whatever
	--LG.draw(g.canvas.hud,g.camera.x,g.camera.y,0,1,1,0,0) --just like draws everything to the hud or whatever
end

return screen