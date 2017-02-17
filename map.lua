local function generate(w,h)
	local m={}
	for y=1,h do
		table.insert(m,{})
		for x=1,w do
			if x==1 or x==w or y==1 or y==h then
				local f=Enums.flags.solid
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
				--makewall((b-1)*TileW, (a-1)*TileH, TileW, TileH) --each cell that has a wall flag loads a wall entity
				actor.make(0,0,(b-1)*TileW+TileW/2, (a-1)*TileH+TileH/2, TileW, TileH) --each cell that has a wall flag loads a wall entity
			end
		end
	end
	return map
end

local function draw(m)
	local tw,th=Game.tile.width,Game.tile.height
	--love.graphics.setColor(Palette[Enums.colours.dark_blue])
	love.graphics.setColor(32,51,123,120)
	for y=1,#m-1 do
		love.graphics.line(0,y*th+1,Game.width,y*th+1)
	end
	for x=1,#m[1]-1 do
		love.graphics.line(x*tw+1,0,x*tw+1,Game.height)
	end
	--for x=1,#m[y] do
		
	--end
	--draws the map, YO
--[[
	for b=1,#m do
		for a=1,#m[b] do
			--love.graphics.draw( Spritesheet, Quads[ bit.band(m[b][a] - 1, 0x0000ffff) ],(a-1)*TileW,(b-1)*TileH) --bitwise AND is to get just the rightmost 16 bits (non-flag integer)
			love.graphics.print(m[b][a],(a-1)*TileW,(b-1)*TileH) --bitwise AND is to get just the rightmost 16 bits (non-flag integer)
		end
	end
--]]
end

return
{
	generate = generate,
	getcell = getcell,
	load = load,
	draw = draw,
}