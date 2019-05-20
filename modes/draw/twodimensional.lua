local twodimensional={}

twodimensional.draw = function(g,a)
--[[
	run(EA[a.t],"predraw",a)
--]]

	local c=a.c or "pure_white"
	--local c=a.c or g.actordata[EA[a.t]].c
	local r,gr,b=unpack(g.palette[c])
	local alpha=255
	if a.alpha then
		alpha=a.alpha
	end
	LG.setColor(r,gr,b,alpha)
	sprites.draw(a)

--[[
	if a.char then
		LG.print(a.char,a.x,a.y)
	end
--]]

	--actordata
	--if a.t then
		run(EA[a.t],"draw",g,a)--actor's specific draw function (ie snake.draw)
	--end

	if a.tail then
		tail.draw(a.tail)
	end

	if Debugger.debugging then
		LG.setColor(g.palette["blue"])
		if a.hitradius then
			hitradius.draw(a)
		elseif a.hitbox then
			hitbox.draw(a)
		end
		LG.points(a.x,a.y)
		if a.deltimer then
			LG.print(a.deltimer,a.x,a.y)
		end
		--LG.print(a.flags,a.x+8,a.y-8)
	end

	LG.setColor(g.palette["pure_white"])
end

return twodimensional