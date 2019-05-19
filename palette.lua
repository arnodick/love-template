local palette={}

palette.load = function(g,...)
	--TODO name palettes in palettes array instead of index?
	--TODO use game.files or utils file load here instead?
	local filenames={...}
	g.palettes={}
	for i,v in ipairs(filenames) do
		table.insert(g.palettes,json.load(v))
	end
	palette.set(g,1)
end

palette.set = function(g,i)
	g.palettes.i=i
	g.palette={}
	supper.copy(g.palette,g.palettes[g.palettes.i])
end

--UNUSED
palette.colourswap = function(c1,c2)
	Game.palette[c1]=Game.palettes[Game.palettes.i][c2]
end

--UNUSED
palette.generate = function()
	local table = {love.math.random(255),love.math.random(255),love.math.random(255)}
	return table
end

return palette