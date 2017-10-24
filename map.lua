--do this like denver, array of function like generators.wall
--send string "wall" into generator function to call the generators.wall function
--if table of string, do each of those generators in array order

local map={}
local generators={}
local drawmodes={}

map.generate = function(gen,w,h,args)
	local m={}

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
	return m
end

map.load = function(m)
	--loads map sprites and walls/entities from a hex populated textfile
	--returns map array
	local map = textfile.load(m) --each cell (flags + integer) is loaded into map array
	for a=1, #map do
		for b=1, #map[a] do
			--TODO make this dynamic, loads entities based on flag value
			if getflag(map[a][b], Enums.wall) then
				actor.make(0,0,(b-1)*TileW+TileW/2, (a-1)*TileH+TileH/2, TileW, TileH) --each cell that has a wall flag loads a wall entity
			end
		end
	end
	return map
end

map.draw = function(m,drawmode)
	drawmodes[drawmode](m)
end

map.getcell = function(m,x,y)
	local tw,th=Game.tile.width,Game.tile.height
	local cx,cy=math.floor((x+tw)/tw),math.floor((y+th)/th)
	cx=math.clamp(cx,1,#m[1])
	cy=math.clamp(cy,1,#m)
	return cx,cy
end



generators.walls = function(m,w,h,x,y)
	if x==1 or x==w or y==1 or y==h then
		--TODO flag stuff screws up games that don't use flags, figure this out in game-specific code
		local f=bit.lshift(1,(EF.solid-1))--converts an integer into its bit position
		f=bit.lshift(f,16)
		m[y][x]=f
	end
end

generators.random = function(m,w,h,x,y,args)
	local pool=args.pool
	m[y][x]=pool[love.math.random(#pool)]
end

generators.increment = function(m,w,h,x,y)
	m[y][x]=x+(y-1)*w
end



drawmodes.grid = function(m)
	local tw,th=Game.tile.width,Game.tile.height
	if Game.levels then
		local c=Game.palette[Game.levels.current.c]
		local r=c[1]
		local g=c[2]
		local b=c[3]
		LG.setColor(r,g,b,120)
	else
		LG.setColor(Game.palette[EC.red])
	end

	for y=1,#m-2 do
		LG.line(0,y*th+1,Game.width,y*th+1)
	end
	for x=1,#m[1]-2 do
		LG.line(x*tw+1,0,x*tw+1,Game.height)
	end
end

drawmodes.numbers = function(m)
	local tw,th=Game.tile.width,Game.tile.height
	for y=1,#m do
		for x=1,#m[y] do
			local value=m[y][x]
			LG.print(value,(x-1)*tw,(y-1)*th)
		end
	end
end

drawmodes.isometric = function(m)
	local tw,th=Game.tile.width,Game.tile.height
	local t=Game.timer

	for y=1,#m do
		for x=1,#m[y] do
			--if (y-1)*#m[y]+x<=t then
				local isox=(x-1)*tw/2
				local isoy=(y-1)*th/4
				local value=m[y][x]
				--LG.draw(Spritesheet[3],Quads[3][value],isox+230,isoy+50,0,1,1,(y-1)*tw/2,(x-1)*-th/4)
				LG.draw(Spritesheet[3],Quads[3][value],isox,isoy,0,1,1,(y-1)*tw/2,(x-1)*-th/4)
				if Debugger.debugging then
					LG.points(isox,isoy)
				end
				
			--end
		end
	end
end

return map