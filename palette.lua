local palette={}

palette.load = function(g,...)
	g.palettes=library.load("palettes")
	palette.set(g,1)--can also do palette.set(g,"palette")
	supper.print(g.palettes,"palette")
end

palette.set = function(g,i)
	g.palettes.i=i
	g.palette={}
	supper.copy(g.palette,g.palettes[g.palettes.i])--copy palette
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