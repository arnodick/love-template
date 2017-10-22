--do this like denver, array of function like generators.wall
--send string "wall" into generator function to call the generators.wall function
--if table of string, do each of those generators in array order

local map={}
local generators={}

map.generate = function(t,gen,w,h,...)
	local m={}
	m.t=t

	generators[gen](m,w,h,...)
	--if _G[Enums.games.maps[m.t]]["generate"] then
	--	_G[Enums.games.maps[m.t]]["generate"](m,w,h)
	--end
	return m
end

map.load = function(m)
	--loads map sprites and walls/entities from a hex populated textfile
	--returns map array
	local map = textfile.load(m) --each cell (flags + integer) is loaded into map array
	for a=1, #map do
		for b=1, #map[a] do
			if getflag(map[a][b], Enums.wall) then
				actor.make(0,0,(b-1)*TileW+TileW/2, (a-1)*TileH+TileH/2, TileW, TileH) --each cell that has a wall flag loads a wall entity
			end
		end
	end
	return map
end

map.draw = function(m)
	if _G[Enums.games.maps[m.t]]["draw"] then
		_G[Enums.games.maps[m.t]]["draw"](m)
	end
end

map.getcell = function(m,x,y)
	local tw,th=Game.tile.width,Game.tile.height
	local cx,cy=math.floor((x+tw)/tw),math.floor((y+th)/th)
	cx=math.clamp(cx,1,#m[1])
	cy=math.clamp(cy,1,#m)
	return cx,cy
end

generators.walls = function(m,w,h)
	for y=1,h do
		table.insert(m,{})
		for x=1,w do
			if x==1 or x==w or y==1 or y==h then
				local f=bit.lshift(1,(EF.solid-1))--converts an integer into its bit position
				f=bit.lshift(f,16)
				table.insert(m[y],f)
			else
				table.insert(m[y],0)
			end
		end
	end
end

generators.random = function(m,w,h,pool)
	for y=1,h do
		table.insert(m,{})
		for x=1,w do
			table.insert(m[y],pool[love.math.random(#pool)])
		end
	end
end

generators.increment = function(m,w,h)
	for y=1,h do
		table.insert(m,{})
		for x=1,w do
			table.insert(m[y],x+(y-1)*w)
		end
	end
end

return map