--do this like denver, array of function like generators.wall
--send string "wall" into generator function to call the generators.wall function
--if table of string, do each of those generators in array order

local map={}
local generators={}
local drawmodes={}
map.flat={}

--TODO could probably do away with this by just checking if m.tile exists in code
map.init = function(m,w,h)
	if w and h then
		m.w,m.h=w,h
	end
	if not m.tile then
		m.tile={width=8,height=8}
	end
	m.width=map.width(m)
	m.height=map.height(m)
end

map.generate = function(m,gen,flat)
	local w,h=m.w,m.h
	local args=m.args

	m.flat=flat

	--TODO MAP FLATTEN
	if not m.flat then
		for y=1,h do
			table.insert(m,{})
			for x=1,w do
				table.insert(m[y],0)
				if type(gen)=="table" then
					for i,v in ipairs(gen) do
						generators[v](m,w,h,x,y,args)
					end
				else
					generators[gen](m,w,h,x,y,args)
				end
			end
		end
		m.width=map.width(m)
		m.height=map.height(m)
	else
		for xy=1,w*h do
			table.insert(m,0)
			local x=(xy-1)%w+1
			local y=math.floor(xy/h)+1
			if type(gen)=="table" then
				for i,v in ipairs(gen) do
					generators[v](m,w,h,x,y,args)
				end
			else
				generators[gen](m,w,h,x,y,args)
			end
		end
		-- map.init(m)
		m.width=m.w*m.tile.width
		m.height=m.h*m.tile.height
	end
end

map.load = function(m,filename,flat)
	--loads map sprites and walls/entities from a hex populated textfile
	--returns map array
	local mapgrid=textfile.load(filename,flat) --each cell (flags + integer) is loaded into map array
	supper.copy(m,mapgrid)
	m.flat=flat
	print("MAP FLAT:")
	print(m.flat)

	--TODO do actorspawn flag stuff here to load actor from value of tile
	if not flat then
		map.init(m,map.cellwidth(m),map.cellheight(m))
	else
		map.init(m)
	end

	-- supper.print(m)

	return m
end

map.flat.generate = function(m,gen)
end

map.flat.load = function(m,filename)
	local mapflat=textfile.flat.load(filename)
	print(mapflat)
	-- return mapflat
end

map.flat.getxy = function(m,x,y)
-- 	print("MAP")
-- 	print(m)
-- print("X")
-- print(x)
-- print("Y")
-- print(y)
-- 	print("M.W")
-- 	print(m.w)
	return (y-1)*m.w+x
end

map.flat.setxy = function(m,x,y,v)
	m[map.flat.getxy(m,x,y)]=v
end

--this should work fine with flat maps, just does one row
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

--TODO ALL maps should have w h width height
--TODO get rid of this once map is flattended
map.cellwidth = function(m)
	--TODO MAP FLATTEN is this possible any more?
	return #m[1]
end

--TODO get rid of this once map is flattended
map.width = function(m)
	if not m.flat then
		return map.cellwidth(m)*m.tile.width
	else
		return m.w*m.tile.width
	end
end

--TODO get rid of this once map is flattended
map.cellheight = function(m)
	--TODO MAP FLATTEN is this possible any more?
	return #m
end

--TODO get rid of this once map is flattended
map.height = function(m)
	if not m.flat then
		return map.cellheight(m)*m.tile.height
	else
		return m.h*m.tile.height
	end
end

map.inbounds = function(m,x,y)
	if not m.flat then
		if m[y] then
			return m[y][x]
		end
	else
		local xy=map.flat.getxy(m,x,y)
		if x>0 and x<=m.w then
			if y>0 and y<=m.h then
				return m[xy]
			end
		end
	end
	return nil
end

--TODO MAP FLATTEN
map.solid = function(m,x,y)
	local mapcell=m
	if type(m)=="table" then
		--TODO if x and y here?
		mapcell=m[y][x]
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

map.getcellraw = function(m,x,y)
	local cx,cy=map.getcellcoords(m,x,y)
	if not m.flat then
		return m[cy][cx]
	else
		return m[map.flat.getxy(m,cx,cy)]
	end
end

-- TODO world coords weirdness
map.getcellvalue = function(m,x,y,cell)--takes world x,y coordinates and returns the value of the cell under those coordinates
	local cx,cy=x,y
	if not cell then
		print("NOT CELL")
		cx,cy=map.getcellcoords(m,x,y)
	end

	if not m.flat then
		return flags.strip(m[cy][cx])
	else
		local mval=m[map.flat.getxy(m,cx,cy)]
		print("M VAL")
		print(mval)
		return flags.strip(mval)
	end
end

map.setcellvalue = function(m,x,y,v,worldcoords)--sets the value of a map cell in the low 16 bits while retaining the flags in the high 16 bits
	if worldcoords then
		x,y=map.getcellcoords(m,x,y)
	end
	if not m.flat then
		m[y][x]=bit.bor(flags.isolate(m[y][x]),v)
	else
		local xy=map.flat.getxy(m,x,y)
		m[xy]=bit.bor(flags.isolate(m[xy]),v)
	end
end

map.getcellflags = function(m,x,y,shift)
	shift=shift or 16
	local cx,cy=map.getcellcoords(m,x,y)
	if not m.flat then
		local c=m[cy][cx]
		return bit.rshift(c,shift)
	else
		local c=m[map.flat.getxy(m,cx,cy)]
		return bit.rshift(c,shift)
	end
end

map.setcellflag = function(m,x,y,v,worldcoords)--sets a flag on the high 16 bits of a map cell while retaining the value in the low 16 bits
	local f=flags.fromenum(v)
	f=bit.lshift(f,16)
	if worldcoords then
		x,y=map.getcellcoords(m,x,y)
	end
	if not m.flat then
		m[y][x]=bit.bor(m[y][x],f)
	else
		local xy=map.flat.getxy(m,x,y)
		m[xy]=bit.bor(m[xy],f)
	end
end

map.erase = function(m)
	for i,v in ipairs(m) do
		m[i]=0
	end
end

map.erasecellflags = function(m,x,y,worldcoords)
	if worldcoords then
		x,y=map.getcellcoords(m,x,y)
	end
	if not m.flat then
		m[y][x]=flags.strip(m[y][x])
	else
		local xy=map.flat.getxy(m,x,y,m.flat)
		m[xy]=flags.strip(m[xy])
	end
end

generators.empty = function(m,w,h,x,y)
	map.setcellvalue(m,x,y,0)
end

generators.walls = function(m,w,h,x,y)
	if x==1 or x==w or y==1 or y==h then
		map.setcellflag(m,x,y,EF.solid)
		--map.setcellvalue(m,x,y,3)
	end
end

generators.random = function(m,w,h,x,y,args)
	local pool=args.pool
	local v=pool[love.math.random(#pool)]
	if not m.flat then
		m[y][x]=v
	else
		map.flat.setxy(m,x,y,v)
	end
	--[[
	if v==2 or v==3 or v==4 then
		map.setcellflag(m,x,y,EF.animated)
	end
--]]
end

generators.increment = function(m,w,h,x,y)
	if not m.flat then
		m[y][x]=x+(y-1)*w
	else
		map.setxy(m,x,y,x+(y-1)*w)
	end
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
	local g=Game
	if x==1 or y==1 then
		local tw,th=m.tile.width,m.tile.height
		local c=g.palette[g.level.c or "white"]
		local r,gr,b=c[1],c[2],c[3]
		-- LG.setColor(r,gr,b,120)
		--TODO does this work w new color values?
		LG.setColor(r,gr,b,0.47)

		if x==1 then
			--LG.line(0,y*th,map.width(m),y*th)
			LG.line(0,y*th,map.width(m),y*th)
		end
		if y==1 then
			LG.line(x*tw,0,x*tw,map.height(m))
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
	local s=Sprites[1]
	local tw,th=m.tile.width,m.tile.height
	local value=map.getcellvalue(m,x,y,true)
	LG.draw(s.spritesheet,s.quads[value],(x-1)*tw,(y-1)*th)
end

drawmodes.characters = function(m,x,y)
	local tw,th=m.tile.width,m.tile.height
	local value=map.getcellvalue(m,x,y,true)
	LG.print(string.char(value),(x-1)*tw,(y-1)*th)

	-- if m.flat then
	-- 	local xy=map.flat.getxy(m,x,y)
	-- 	local value=flags.strip(m[xy])
	-- 	LG.print(string.char(value),(x-1)*tw,(y-1)*th)
	-- else
	-- 	local value=flags.strip(m[y][x])
	-- 	LG.print(string.char(value),(x-1)*tw,(y-1)*th)
	-- end
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