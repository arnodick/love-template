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

	local xdest,ydest=a.x + a.vec[1]*a.vel*a.speed*gs,a.y - a.vec[2]*a.vel*a.speed*gs
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
--[[
	--local x,y=map.getcell(Game.map,Game.player.x,Game.player.y)
	--local x,y=Game.player.x*tw/2,Game.player.y*th/4
	local tw,th=Game.tile.width,Game.tile.height
	--local isox=(x-1)*tw/2
	--local isoy=(y-1)*th/4
	local isox=(a.x)/2
	local isoy=(a.y)/4
	
	--LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],isox+230,isoy+50,a.angle,1,1,(y-1)*tw/2,(x-1)*-th/4)
	--LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],isox+230,isoy+50,a.angle,1,1,(y-1)*tw/2+(a.size*tw)/2,(x-1)*-th/4+(a.size*th)/2)
	--LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],isox,isoy,a.angle,1,1,(y-1)*tw/2+(a.size*tw)/2,(x-1)*-th/4+(a.size*th)/2)
	LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],isox,isoy,a.angle,1,1,0,0)
--]]

	local tw,th=Game.tile.width,Game.tile.height
	local x,y=map.getcell(Game.map,a.x,a.y)
	--local isox=(x-1)*tw/2
	--local isoy=(y-1)*th/4
	local isox=a.x/2
	local isoy=a.y/4
	--LG.draw(Spritesheet[3],Quads[3][value],isox+230,isoy+50,0,1,1,(y-1)*tw/2,(x-1)*-th/4)
	LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],isox,isoy,0,1,1,(y-1)*tw/2,(x-1)*-th/4)
	if Debugger.debugging then
		LG.points(isox,isoy)
	end
end

return
{
	control = control,
	draw = draw,
}