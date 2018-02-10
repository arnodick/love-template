local function control(a,gs)
	if a.controller then
		local c=a.controller.move
		if c then
			a.vec[1]=c.movehorizontal
			a.vec[2]=c.movevertical
		end
	end

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
			run(EA[Game.name][a.t],"collision",a)
		end
	end
end

--[[
local function draw()
	
end
--]]

return
{
	control = control,
	--draw = draw,
}