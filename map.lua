local function generate(w,h)
	local m={}
	for y=1,h do
		table.insert(m,{})
		for x=1,w do
			if x==1 or x==w or y==1 or y==h then
				local f=EF.solid
				f=bit.lshift(f,16)
				table.insert(m[y],f)
			else
				table.insert(m[y],0)
			end
		end
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
	local tw,th=Game.tile.width,Game.tile.height
	local c=Game.palette[Game.levels.current.c]
	local r=c[1]
	local g=c[2]
	local b=c[3]
	LG.setColor(r,g,b,120)
	for y=1,#m-1 do
		LG.line(0,y*th+1,Game.width,y*th+1)
	end
	for x=1,#m[1]-1 do
		LG.line(x*tw+1,0,x*tw+1,Game.height)
	end
end

return
{
	generate = generate,
	getcell = getcell,
	load = load,
	draw = draw,
}