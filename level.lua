local level={}

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

level.make = function(g,index,mode)
	local l={}
	if mode then
	--TODO put if mode==string then l.modename=mode etc
	--l.mode=Enums.games.modes[mode]
	--TODO put this in json file
		l.mode=mode
		l.modename=Enums.modes[mode]
	end
	if not g.levels then
		g.levels={}
	end
	g.levels.index=index
	if g.levels[index] then
		copytable(l,g.levels[index])
	end
	if l.map then
		if l.map.file then
			--l.map=map.load("/maps/"..l.map.file..".txt")
			map.load(l.map,"/maps/"..l.map.file..".txt")
		elseif l.map.generators then
			map.generate(l.map,l.map.generators)
		end
		l.canvas={background=LG.newCanvas(l.map.w*l.map.tile.width,l.map.h*l.map.tile.height)}
		l.bgdraw=true
	end
	g.level=l
	game.state.run(g.name,"level","make",g,l,index)
end

return level