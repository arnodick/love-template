local roguelike={}

roguelike.control = function(a,m,gs)
	if a.controller then
		local c=a.controller.move
		if c then
			a.vec[1]=c.horizontal
			a.vec[2]=c.vertical
		end
	end

	local xdest,ydest=a.x+a.vec[1],a.y+a.vec[2]
	
	local xmapcell=m[a.y][xdest]
	local ymapcell=m[ydest][a.x]
	local collx,colly=false,false

	if Game.step==true then
		if not flags.get(xmapcell,EF.solid,16) then
			a.x = xdest
		else
			collx=true
		end
		if not flags.get(ymapcell,EF.solid,16) then
			a.y = ydest
		else
			colly=true
		end

		if collx or colly then
			run(EA[a.t],"collision",a)
		end
	end
end

roguelike.draw = function(g,a)
	if a.char then
		local m=g.level.map
		LG.setColor(100,200,100)
		LG.print(a.char,(a.x-1)*m.tile.width,(a.y-1)*m.tile.height)
	end
end

return roguelike