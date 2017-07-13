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

	local xdest,ydest=a.x + a.vec[1]*8,a.y - a.vec[2]*8
	a.x = xdest
	a.y = ydest
--[[
	local tw,th=Game.tile.width,Game.tile.height

	local xcell,ycell=map.getcell(Game.map,a.x,a.y)
	local xdest,ydest=a.x + a.vec[1]*tw,a.y - a.vec[2]*th
	local xcelldest,ycelldest=map.getcell(Game.map,xdest,ydest)
	
	local xmapcell=Game.map[ycell][xcelldest]
	local ymapcell=Game.map[ycelldest][xcell]
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
			if _G[EA[Game.name][a.t] ]["collision"] then
				_G[EA[Game.name][a.t] ]["collision"](a)
			end
		end
	end
--]]
end

local function draw(a)
	LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],a.x,a.y,a.angle,1,1,(a.size*8)/2,(a.size*8)/2)
end

return
{
	control = control,
	draw = draw,
}