local function control(g,s,...)
	local shake=love.math.random(-s.shake/4,s.shake/4)*s.scale

	LG.draw(g.canvas.main,(g.width*s.scale/2)+s.xoff+shake,(g.height*s.scale/2)+s.yoff,0,s.scale*g.camera.zoom,s.scale*g.camera.zoom,g.width/2,g.height/2) --just like draws everything to the screen or whatever
end

return
{
	control = control,
}