--do this like denver, array of function like generators.wall
--send string "wall" into generator function to call the generators.wall function
--if table of string, do each of those generators in array order

local map={}
local generators={}
local drawmodes={}

--TODO could probably do away with this by just checking if m.tile exists in code
map.init = function(m,w,h)
	if w and h then
		m.w,m.h=w,h
	end
	if not m.tile then
		m.tile={width=8,height=8}
	end
	m.width=m.w*m.tile.width
	m.height=m.h*m.tile.height
end

map.generate = function(m,gen)
	local w,h=m.w,m.h
	local args=m.args

	for index=1,w*h do
		table.insert(m,0)
		local x,y=map.getxy(m,index)
		if type(gen)=="table" then
			for i,v in ipairs(gen) do
				generators[v](m,w,h,x,y,args)
			end
		else
			generators[gen](m,w,h,x,y,args)
		end
	end
	map.init(m)
end

map.load = function(m,filename)
	--loads map sprites and walls/entities from a hex populated textfile
	--returns map array
	local mapgrid,w,h=textfile.load(filename) --each cell (flags + integer) is loaded into map array
	supper.copy(m,mapgrid)

	--TODO do actorspawn flag stuff here to load actor from value of tile

	map.init(m,w,h)

	-- supper.print(m)

	return m
end

--converts x and y coordinates into the corresponding index value in a map
--ie if map w and h are 8, if x==1 and y==1, then index==1, if x==1 and y==2, then index==9
map.getindex = function(m,x,y)
	return (y-1)*m.w+x
end

--converts an index from a map into x and y values
--ie if map w and h are 8, if index==1 then x==1 and y==1, if index==9 then x==1 and y==2
map.getxy = function(m,index)
	return (index-1)%m.w+1,math.ceil(index/m.w)
end

map.save = function(m,filename)
	textfile.save(m,filename)
end

map.draw = function(m,drawmode)
	for y=1,m.h do
		for x=1,m.w do
			if type(drawmode)=="table" then
				for i,v in ipairs(drawmode) do
					drawmodes[v](m,x,y)
				end
			else
				drawmodes[drawmode](m,x,y)
			end
		end
	end
end

--TODO ALL maps should have w h width height, tile.width/height

--TODO cell option
map.inbounds = function(m,x,y)
	-- local index=map.getindex(m,x,y)
	if x>0 and x<=m.w then
		if y>0 and y<=m.h then
			-- return m[index]
			return map.getcellraw(m,x,y,true)
		end
	end
	return nil
end

map.solid = function(m,x,y)
	local mapcell=m
	if type(m)=="table" then
		--TODO if x and y here?
		mapcell=map.getcellraw(m,x,y,true)
	end
	return flags.get(mapcell,EF.solid,16)
end

map.getcellcoords = function(m,x,y)--returns the cell coords of worldspace coords
	local tw,th=m.tile.width,m.tile.height
	local cx,cy=math.floor((x+tw)/tw),math.floor((y+th)/th)
	cx=math.clamp(cx,1,m.w)
	cy=math.clamp(cy,1,m.h)
	return cx,cy
end

--TODO cell cleanup, should we input cell or not? make consistent with rest of stuff
map.getcellraw = function(m,x,y,cell)
	local cx,cy=x,y
	if not cell then
		cx,cy=map.getcellcoords(m,x,y)
	end
	return m[map.getindex(m,cx,cy)]
end

--sets an index of a map using x and y values to v
map.setcellraw = function(m,x,y,v)
	m[map.getindex(m,x,y)]=v
end

-- TODO world coords weirdness
map.getcellvalue = function(m,x,y,cell)--takes world x,y coordinates and returns the value of the cell under those coordinates
	local cx,cy=x,y
	if not cell then
		cx,cy=map.getcellcoords(m,x,y)
	end

	local mval=m[map.getindex(m,cx,cy)]
	return flags.strip(mval)
end

map.setcellvalue = function(m,x,y,v,cell)--sets the value of a map cell in the low 16 bits while retaining the flags in the high 16 bits
	if not cell then
		x,y=map.getcellcoords(m,x,y)
	end

	local index=map.getindex(m,x,y)
	m[index]=bit.bor(flags.isolate(m[index]),v)
end

map.getcellflags = function(m,x,y,shift)
	shift=shift or 16
	local cx,cy=map.getcellcoords(m,x,y)
	local c=m[map.getindex(m,cx,cy)]
	return bit.rshift(c,shift)
end

map.setcellflag = function(m,x,y,v,worldcoords)--sets a flag on the high 16 bits of a map cell while retaining the value in the low 16 bits
	local f=flags.fromenum(v)
	f=bit.lshift(f,16)
	if worldcoords then
		x,y=map.getcellcoords(m,x,y)
	end

	local index=map.getindex(m,x,y)
	m[index]=bit.bor(m[index],f)
end

map.erasecellflags = function(m,x,y,worldcoords)
	if worldcoords then
		x,y=map.getcellcoords(m,x,y)
	end

	local index=map.getindex(m,x,y)
	m[index]=flags.strip(m[index])
end

map.erase = function(m)
	for i,v in ipairs(m) do
		m[i]=0
	end
end

generators.empty = function(m,w,h,x,y)
	map.setcellvalue(m,x,y,0)
end

generators.walls = function(m,w,h,x,y)
	if x==1 or x==w or y==1 or y==h then
		map.setcellflag(m,x,y,EF.solid)
	end
end

generators.random = function(m,w,h,x,y,args)
	local pool=args.pool
	local v=pool[love.math.random(#pool)]

	map.setcellraw(m,x,y,v)
	--[[
	if v==2 or v==3 or v==4 then
		map.setcellflag(m,x,y,EF.animated)
	end
--]]
end

generators.increment = function(m,w,h,x,y)
	map.setcellraw(m,x,y,x+(y-1)*w)
end

generators.solid = function(m,w,h,x,y,args)
	local c=map.getcellvalue(m,x,y,true)
	--args.solid is a list of numbers, if the value in the cell is in args.solid then set the solid cell flag
	for i,v in ipairs(args.solid) do
		if v==c then
			--print(c)
			map.setcellflag(m,x,y,EF.solid)
		end
	end
end

--TODO MAP FLATTEN is this possible any more?
generators.buildings = function(m,w,h,x,y,args)
	if love.math.random(args.buildings.chance)==1 then
		local door=false
		local width,height=love.math.random(args.buildings.width.min,args.buildings.width.max),love.math.random(args.buildings.width.min,args.buildings.width.max)
		for i=x,x-width,-1 do
			if i>0 and i<w then
				if door==false and love.math.random(10)==1 then
					m[y][i]=59
					door=true
				else
					m[y][i]=43
					map.setcellflag(m,i,y,EF.solid)
				end
				if y-height>0 and y-height<h then
					m[y-height][i]=11
					map.setcellflag(m,i,y-height,EF.solid)
				end
			end
		end
		for i=y,y-height,-1 do
			if i>0 and i<h then
				if i==y then
					m[i][x]=44
				elseif i==y-height then
					m[i][x]=12
				else
					m[i][x]=28
				end
				map.setcellflag(m,x,i,EF.solid)

				if x-width>0 and x-width<w then
					if i==y then
						m[i][x-width]=42
					elseif i==y-height then
						m[i][x-width]=10
					else
						m[i][x-width]=26
					end
					map.setcellflag(m,x-width,i,EF.solid)
				end
			end
		end
	end
end

drawmodes.grid = function(m,x,y)
	if x==1 or y==1 then
		local g=Game
		local tw,th=m.tile.width,m.tile.height
		local c=g.palette[g.level.c or "white"]
		local r,gr,b=c[1],c[2],c[3]
		-- LG.setColor(r,gr,b,120)
		--TODO does this work w new color values?
		LG.setColor(r,gr,b,0.47)

		if x==1 then
			local yh=y*th
			LG.line(0,yh,m.width,yh)
		end
		if y==1 then
			local xw=x*tw
			LG.line(xw,0,xw,m.height)
		end
		LG.setColor(g.palette["pure_white"])
	end
end

drawmodes.numbers = function(m,x,y)
	local tw,th=m.tile.width,m.tile.height
	-- local value=m[y][x]
	local value=map.getcellvalue(m,x,y,true)--TODO getcellraw here instead?
	LG.print(value,(x-1)*tw,(y-1)*th)
end

drawmodes.sprites = function(m,x,y)
	local value=map.getcellvalue(m,x,y,true)
	if value~=0 then--doing this because sprite 0 is all black and will overdraw other drawmodes
		local s=Sprites[1]
		LG.draw(s.spritesheet,s.quads[value],(x-1)*m.tile.width,(y-1)*m.tile.height)
	end
end

drawmodes.characters = function(m,x,y)
	local tw,th=m.tile.width,m.tile.height
	local value=map.getcellvalue(m,x,y,true)
	local g=Game
	if g.things then
		print(value)
		local object=g.things[value]
		if object then
			LG.print({supper.random(object.colours),string.char(value)},(x-1)*tw,(y-1)*th)
		end
	else
		LG.print(string.char(value),(x-1)*tw,(y-1)*th)
	end
end

drawmodes.isometric = function(m,x,y)
	local tw,th=m.tile.width,m.tile.height
	local t=Game.timer

	--if (y-1)*#m[y]+x<=t then
	local isox,isoy=(x-1)*tw/2+m.width/2,(y-1)*th/4+m.height/2
	-- local value=flags.strip(m[y][x])
	local value=map.getcellvalue(m,x,y,true)

	LG.draw(Sprites[3].spritesheet,Sprites[3].quads[value],isox,isoy,0,1,1,(y-1)*tw/2,(x-1)*-th/4)
	if Debugger.debugging then
		LG.points(isox,isoy)
	end	
	--end
end

return map