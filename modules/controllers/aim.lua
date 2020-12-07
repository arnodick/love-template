local aim={}

aim.make = function(a,c)
	c.horizontal=0
	c.vertical=0
end

aim.control = function(a,c,gs,c1,c2)
-- local dir2=vector.direction(c1,c2,a.x,a.y)
	if c.input==EMCI.mouse then
		-- local dir=vector.direction(a.x,a.y,c1,c2)--TODO BACKWARDS!?
		local dir=vector.direction(c1,c2,a.x,a.y)
		
		-- print("DIR BACKWARDS: "..dir)
		-- print("DIR FORWARDS:  "..dir2)

		--TODO WHY NEGATIVE!?
		c1=-math.cos(dir)
		c2=-math.sin(dir)
	end
	-- print("HOR B: "..c1.." VER B: "..c2)
	-- print("HOR F: "..math.cos(dir2).." VER F: "..math.sin(dir2))
	c.horizontal,c.vertical=c1,c2
	--controller.deadzone(c,0.25)
end

return aim