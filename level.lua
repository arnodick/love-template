local level={}
--local modes={}

level.load = function(g,dir,ext)
	--loads a folder of ini files from a folder into the g.levels table, so they can be accessed quickyl by the game
	--ie: ALL level info is loaded at the start of the game, each level is then accessed from the g.levels when it is loaded
	--each file in the folder gets its own table in l
	--uses LIP, so each section of the ini gets its own table ie: l[1]={enemies={...},values={c=1},etc}
	--as a result, a level in l can't have single values assigned to it, and each value must be part of a table
	local l={}
	local files=love.filesystem.getDirectoryItems(dir)
	for i=1,#files do
		local file=files[i]
		if love.filesystem.isFile(dir.."/"..file) then --if it isn't a directory
			local filedata=love.filesystem.newFileData("code", file) --gets each file's filedata, so we can determine their extensions
			local filename=filedata:getFilename() --get the file's name
			if filedata:getExtension()==ext then
				local f=string.gsub(filename, "."..ext, "")--strip the file extension
				if tonumber(f) then--if the file has a number as its name, it will be indexed in the table by integer
					if ext=="ini" then
						l[tonumber(f)]=LIP.load(dir.."/"..filename)
					elseif ext=="json" then
						l[tonumber(f)]=json.load(dir.."/"..filename)
					end
				else--if the file has a string name, it will be indexed in the table by a string key
					if ext=="ini" then
						l[f]=LIP.load(dir.."/"..filename)
					elseif ext=="json" then
						l[f]=json.load(dir.."/"..filename)
					end
				end
			end
		end
	end
	g.levels=l
end

level.make = function(g,index,mode,tw,th)
	local l={}
	if mode then
		l.mode=mode
		l.modename=Enums.games.modes[mode]
	end
	if not g.levels then
		g.levels={}
	end
	g.levels.index=index
	if tw and th then
		l.tile={}
		l.tile.width=tw
		l.tile.height=th
	end
	if g.levels[index] then
		copytable(l,g.levels[index])
	end
	if l.map then
		--l.map=map.load(l.map..".txt")
		l.map=map.load("/games/maps/"..l.map..".txt")
	elseif l.map_generate then
		debugger.printtable(l.map_generate)
		l.map=map.generate(l.map_generate.args,l.map_generate.w,l.map_generate.h)
	end
	game.state.run(g.name,"level","make",g,l,index)
	g.level=l
end

return level