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


--TODO just get rid of these too?
level.make = function(g,index)
	local l={}
	g.levels.index=index
	game.state.run(g.name,"level","make",g,l,index)
	g.levels.current=l
end

level.control = function(g,l)
	game.state.run(g.name,"level","control",g,l)

	if l.transition then
		transition.control(l,l.transition)
	end
end

level.keypressed = function(g,l,key)
	game.state.run(g.name,"level","keypressed",g,l,key)
end

level.keyreleased = function(g,l,key)
	game.state.run(g.name,"level","keyreleased",g,l,key)
end

level.gamepadpressed = function(g,l,button)
	game.state.run(g.name,"level","gamepadpressed",g,l,button)
end

level.draw = function(g,l)
	game.state.run(g.name,"level","draw",g,l)
end

return level