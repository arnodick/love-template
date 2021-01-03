local aim={}

aim.make = function(a,c)
	c.horizontal=0
	c.vertical=0
end

aim.control = function(a,c,gs,c1,c2)
	if c.input==EMCI.mouse then
		local dir=vector.direction(a.x,a.y,c1,c2)
		c1,c2=vector.vectors(dir)
	end
	c.horizontal,c.vertical=c1,c2
	--controller.deadzone(c,0.25)
end

return aim