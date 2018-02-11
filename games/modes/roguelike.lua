local roguelike={}

roguelike.control = function(a,m,gs)
	if a.controller then
		local c=a.controller.move
		if c then
			a.vec[1]=c.horizontal
			a.vec[2]=c.vertical
		end
	end

	local tw,th=Game.tile.width,Game.tile.height

	local xcell,ycell=map.getcell(m,a.x,a.y)
	local xdest,ydest=a.x + a.vec[1]*tw,a.y + a.vec[2]*th
	local xcelldest,ycelldest=map.getcell(m,xdest,ydest)
	
	local xmapcell=m[ycell][xcelldest]
	local ymapcell=m[ycelldest][xcell]
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
			run(EA[Game.name][a.t],"collision",a)
		end
	end
end

roguelike.draw = function(g,a)
	if a.char then
		LG.setColor(100,200,100)
		LG.print(a.char,a.x,a.y)
	end
end

return roguelike