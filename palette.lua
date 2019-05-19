local palette={}

palette.load = function(g,...)
--[[
	local filenames={...}
	local pal={}
	for a=#filenames,1,-1 do
		table.insert(pal,LIP.load(filenames[a]))
	end
	pal.i=1
	debugger.printtable(pal)
	g.palettes=pal
	palette.set(g,g.palettes.i)
	EC=g.palettes[g.palettes.i].colours
	--debugger.printtable(EC)
	return pal
--]]
	local filenames={...}
	debugger.printtable(filenames)
	local pal={}
	for i,v in ipairs(filenames) do
		table.insert(pal,json.load(v))
		supper.names(pal[i],"colours")
	end
	-- for a=#filenames,1,-1 do
	-- 	table.insert(pal,json.load(filenames[a]))
	-- end
	pal.i=1
	debugger.printtable(pal)
	g.palettes=pal
	palette.set(g,g.palettes.i)
	EC=g.palettes[g.palettes.i].colours
	--debugger.printtable(EC)
	return pal
end

palette.set = function(g,i)
	g.palettes.i=i
	g.palette={}
	for a=0,#g.palettes[g.palettes.i] do
		g.palette[a]=g.palettes[g.palettes.i][a]
	end
	-- g.palette.colours=g.palettes[g.palettes.i].colours
	g.palette.colours=g.palettes[g.palettes.i]
end

palette.colourswap = function(c1,c2)
	Game.palette[c1]=Game.palettes[Game.palettes.i][c2]
end

palette.generate = function()
	local table = {love.math.random(255),love.math.random(255),love.math.random(255)}
	return table
end

return palette