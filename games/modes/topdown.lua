local function control(a,gs)
	if a.controller then
		local c=a.controller.move
		if c then
			a.d=vector.direction(c.horizontal,-c.vertical)
			a.vel=vector.length(c.horizontal,c.vertical)
		end
	end
	a.vec[1] = math.cos(a.d)
	a.vec[2] = math.sin(a.d)

	if a.inventory then
		if #a.inventory>0 then
			c=a.controller
			item.use(a.inventory[1],gs,a,c.aim.horizontal,c.aim.vertical,c.action.use)
		end
	end

	local xcell,ycell=map.getcell(Game.map,a.x,a.y)
	local xdest,ydest=a.x + a.vec[1]*a.vel*a.speed*gs,a.y - a.vec[2]*a.vel*a.speed*gs
	local xcelldest,ycelldest=map.getcell(Game.map,xdest,ydest)
	
	local xmapcell=Game.map[ycell][xcelldest]
	local ymapcell=Game.map[ycelldest][xcell]
	local collx,colly=false,false
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
		if _G[EA[Game.name][a.t]]["collision"] then
			_G[EA[Game.name][a.t]]["collision"](a)
		end
		if flags.get(a.flags,EF.bouncy) then
			if collx then
				a.vec[1]=-a.vec[1]
				a.d=vector.direction(a.vec[1],a.vec[2])
			end
			if colly then
				a.vec[2]=-a.vec[2]
				a.d=vector.direction(a.vec[1],a.vec[2])
			end
		end
	end
end

local function draw(a)
	if _G[EA[Game.name][a.t]]["predraw"] then
		_G[EA[Game.name][a.t]]["predraw"](a)
	end

	if not a.c then
		print(EA.protosnake[a.t])
		print(a.c)
	end
	local r,g,b=unpack(Game.palette[a.c])
	local alpha=255
	if a.alpha then
		alpha=a.alpha
	end
	LG.setColor(r,g,b,alpha)
	sprites.draw(a)

	if a.char then
		LG.print(a.char,a.x,a.y)
	end

	if _G[EA[Game.name][a.t]]["draw"] then
		_G[EA[Game.name][a.t]]["draw"](a)
	end

	if a.tail then
		tail.draw(a.tail)
	end

	if Debugger.debugging then
		LG.setColor(Game.palette[EC.blue])
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

	LG.setColor(Game.palette[EC.pure_white])
end

return
{
	control = control,
	draw = draw,
}