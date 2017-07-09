local function generate(t,w,h)
	local m={}
	m.t=t
	if _G[Enums.games.maps[m.t]]["generate"] then
		_G[Enums.games.maps[m.t]]["generate"](m,w,h)
	end
	return m
end

local function getcell(m,x,y)
	local tw,th=Game.tile.width,Game.tile.height
	local cx,cy=math.floor((x+tw)/tw)+1,math.floor((y+th)/th)+1
	cx=math.clamp(cx,1,#m[1])
	cy=math.clamp(cy,1,#m)
	return cx,cy
end

local function load(m)
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

local function draw(m)
	if _G[Enums.games.maps[m.t]]["draw"] then
		_G[Enums.games.maps[m.t]]["draw"](m)
	end
end

return
{
	generate = generate,
	getcell = getcell,
	load = load,
	draw = draw,
}