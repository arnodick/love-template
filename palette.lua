local palette=
{
	load = function(g,...)
		local filenames={...}
		local pal={}
		for a=#filenames,1,-1 do
			table.insert(pal,LIP.load(filenames[a]))
		end
		pal.i=1
		g.palettes=pal
		palette.set(g,g.palettes.i)
		EC=g.palettes[g.palettes.i].colours
		return pal
	end,

	set = function(g,i)
		g.palettes.i=i
		g.palette={}
		for a=0,#g.palettes[g.palettes.i] do
			g.palette[a]=g.palettes[g.palettes.i][a]
		end
		g.palette.colours=g.palettes[g.palettes.i].colours
	end,

	colourswap = function(c1,c2)
		Game.palette[c1]=Game.palettes[Game.palettes.i][c2]
	end,

	generate = function()
		local table = {love.math.random(255),love.math.random(255),love.math.random(255)}
		return table
	end
}

return palette