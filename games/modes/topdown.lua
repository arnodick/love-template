local function control(a,gs)
	if a.controller then
		--local c=a.controller.move
		local c=a.controller.topdown_move
		if c then
			a.d=vector.direction(c.movehorizontal,-c.movevertical)
			a.vel=vector.length(c.movehorizontal,c.movevertical)
		end
	end
	a.vec[1] = math.cos(a.d)
	a.vec[2] = math.sin(a.d)

--[[
	if a.inventory then
		if #a.inventory>0 then
			c=a.controller
			item.use(a.inventory[1],gs,a,c.aim.aimhorizontal,c.aim.aimvertical,c.action.use)
		end
	end
	--]]

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
		if _G[EA[Enums.games[Game.t]][a.t]]["collision"] then
			_G[EA[Enums.games[Game.t]][a.t]]["collision"](a)
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

return
{
	control = control,
}