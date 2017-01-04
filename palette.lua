
local function load(...)
	local filenames={...}
	local pal={}
	for a=#filenames,1,-1 do
		table.insert(pal,LIP.load(filenames[a]))
	end
	pal.i=1
	return pal
end

local function colourswap(c1,c2)
	Palette[c1]=Palettes[Palettes.i][c2]
end

local function generate()
	local table = {love.math.random(255),love.math.random(255),love.math.random(255)}
	return table
end

return
{
	load = load,
	colourswap = colourswap,
	getfiles = getfiles,
}