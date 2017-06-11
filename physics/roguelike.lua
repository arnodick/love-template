local function control(a,gs)
	local tw,th=Game.tile.width,Game.tile.height

	local xcell,ycell=map.getcell(Game.map,a.x,a.y)
	local xdest,ydest=a.x + a.vec[1]*tw,a.y - a.vec[2]*th
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
	end
end

return
{
	control = control,
}