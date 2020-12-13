local camera={}

camera.make = function(g,x,y)
	local c={}
	c.x=x
	c.y=y
	c.zoom=1
	c.hit=0
	c.center={}
	c.center.x,c.center.y=g.width/2,g.height/2
	return c
	--TODO this should insert itself into g.cameras, can have multiple cameras and jump around from one to another
end

camera.control = function(g,c,gs)
	if c.target then
		c.x=c.target.x
		c.y=c.target.y
	elseif c.transition then
		transition.control(g,c,c.transition)
	end
end

return camera