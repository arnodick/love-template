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
end

local function draw(g,a)
	local m=g.level.map
	local tw,th=m.tile.width,m.tile.height
	local x,y=map.getcell(m,a.x,a.y)
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