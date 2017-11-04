local level={}
--local modes={}

level.load = function(g,dir)
	local l={}
	local files = love.filesystem.getDirectoryItems(dir)
	for i=1,#files do
		local file=files[i]
		if love.filesystem.isFile(dir.."/"..file) then --if it isn't a directory
			local filedata = love.filesystem.newFileData("code", file)
			local filename = filedata:getFilename() --get the file's name
			if filedata:getExtension() == "ini" then
				local f = string.gsub(filename, ".ini", "")
				if tonumber(f) then
					l[tonumber(f)]=LIP.load(dir.."/"..filename)
				else
					l[f]=LIP.load(dir.."/"..filename)
				end
			end
		end
	end
	g.levels=l
end

level.make = function(g,index,mode)
	local l={}
	if mode then
		l.mode=mode
		l.modename=Enums.games.modes[mode]
	end
	g.levels.index=index
	game.state.run(g.name,"level","make",g,l,index)
	g.level=l
end

return level