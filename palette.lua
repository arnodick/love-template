local palette={}

palette.load = function(g,...)
	g.palettes=supper.load("palettes")
	for k,v in pairs(g.palettes) do
		supper.names(v)
	end
	palette.set(g,1)--can also do palette.set(g,"palette")--TODO how to deal with this when using supper.load? it's just a json
	-- supper.print(g.palettes,"palette")
end

palette.set = function(g,i)
	g.palettes.i=i
	g.palette={}
	supper.copy(g.palette,g.palettes[g.palettes.i])--copy palette
	-- supper.print(g.palette,"GAME PALETTE")
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