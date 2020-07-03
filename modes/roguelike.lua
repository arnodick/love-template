local roguelike={}

--TODO input g here
roguelike.control = function(a,m,gs,g)
	if g.step==true then
		-- if a.controller then
		-- 	local c=a.controller.move
		-- 	if c then
		-- 		a.vec[1]=c.horizontal
		-- 		a.vec[2]=c.vertical
		-- 	end
		-- end
	
		local xdest,ydest=a.x+a.vec[1],a.y+a.vec[2]

		local ibx=map.inbounds(m,xdest,a.y)
		local iby=map.inbounds(m,a.x,ydest)
		-- print(ibx)
		-- print(iby)
		if ibx and iby then
			-- local collx,colly=map.solid(m,xdest,a.y),map.solid(m,a.x,ydest)
			local collx,colly=map.solid(ibx),map.solid(iby)
			if not collx then
				a.x=xdest
			end
			if not colly then
				a.y=ydest
			end

			if collx or colly then
				print("COLLISION")
				run(EA[a.t],"collision",a)
			end
		end

	end
end

--[[
roguelike.draw = function(g,a)
	if a.char then
		print("true")
		local m=g.level.map
		LG.setColor(100,200,100)--TODO
		LG.print(a.char,(a.x-1)*m.tile.width,(a.y-1)*m.tile.height)
	end
end
--]]

return roguelike