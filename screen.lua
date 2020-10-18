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
	s.pixelscale=1--this is used when doing pixelated transitions
	s.shake=0

	s.draw={}
	s.draw.shake=0

	s.draw.x=(g.width*s.scale/2)+s.xoff+s.draw.shake
	s.draw.y=(g.height*s.scale/2)+s.yoff
	s.draw.scale=s.scale
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

	s.font=LG.newFont("fonts/Kongtext Regular.ttf",8)
	--LG.setFont(s.font)


	s.canvas=LG.newCanvas(gw,gh)--the screen's canvas is the size of the game's dimensions (usually 320x240)
	s.draw.canvas=s.canvas--draw.canvas will almost always be s.canvas, unless there is a pixel transition happening, then it will be set to a temp canvas

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

	s.draw.shake=love.math.random(-s.shake/4,s.shake/4)*s.scale
	s.draw.x=(g.width*s.scale/2)+s.xoff+s.draw.shake
	s.draw.y=(g.height*s.scale/2)+s.yoff
	s.draw.scale=(s.scale/s.pixelscale)*g.camera.zoom

	if s.transition then
		transition.control(s,s.transition)
		s.pixelscale=math.clamp(s.pixelscale,0.1,1)
		s.draw.canvas=LG.newCanvas(g.width*s.pixelscale,g.height*s.pixelscale)
	elseif s.draw.canvas~=s.canvas then
		s.draw.canvas=s.canvas
	end
end

screen.draw = function(g,s,gs)
	LG.setCanvas(s.draw.canvas)--everything(?) is drawn to the screen's canvas, which is the height and width of the game (usually 320x240)
		--local t=math.floor(g.timer/gs)%2 --this makes the game draw half as often, making it fake 30fps
		--if t==0 then
		if s.clear==true then
			LG.clear()
		end
		if g.level then
			if g.level.canvas then
				LG.draw(g.level.canvas.background,-g.camera.x*s.pixelscale,-g.camera.y*s.pixelscale,0,s.pixelscale,s.pixelscale,-g.camera.center.x,-g.camera.center.y)
				-- LG.draw(g.level.canvas.background,-g.camera.x,-g.camera.y,0,1,1,-g.camera.center.x,-g.camera.center.y)
			end
		end
		LG.draw(g.canvas.main,0,0,0,s.pixelscale,s.pixelscale)
		--end
	LG.setCanvas()
	if Shader then
		love.graphics.setShader(Shader)
		LG.draw(s.draw.canvas,s.draw.x,s.draw.y,0,s.draw.scale,s.draw.scale,g.camera.center.x*s.pixelscale,g.camera.center.y*s.pixelscale)
		love.graphics.setShader()
	else
		LG.draw(s.draw.canvas,s.draw.x,s.draw.y,0,s.draw.scale,s.draw.scale,g.camera.center.x*s.pixelscale,g.camera.center.y*s.pixelscale)
	end

	LG.draw(g.canvas.hud,(g.width*s.scale/2)+s.xoff,(g.height*s.scale/2)+s.yoff,0,s.scale,s.scale,g.camera.center.x,g.camera.center.y) --just like draws everything to the hud or whatever
	--LG.draw(g.canvas.hud,g.camera.x,g.camera.y,0,1,1,0,0) --just like draws everything to the hud or whatever
end

return screen