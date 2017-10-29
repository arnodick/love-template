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

level.make = function(g,index)
	local l={}

	game.state.run(g.name,"level","make",g,l,index)

	--calls the level's specific type code ie: city.lua
	--l.t can just become a string ie "city", game-specific level code ie protosnake.level does run(leveltypes[l.t],"make",...)
	if _G[Enums.games.levels[g.name][l.t]]["make"] then
		_G[Enums.games.levels[g.name][l.t]]["make"](g,l)
	end

	g.levels.current=l
end

level.control = function(g,l)
	game.state.run(g.name,"level","control",g,l)

	if _G[Enums.games.levels[g.name][l.t]]["control"] then
		_G[Enums.games.levels[g.name][l.t]]["control"](g,l)
	end
	if l.transition then
		transition.control(l,l.transition)
	end
end

level.keypressed = function(g,l,key)
	game.state.run(g.name,"level","keypressed",g,l,key)

	if _G[Enums.games.levels[g.name][l.t]]["keypressed"] then
		_G[Enums.games.levels[g.name][l.t]]["keypressed"](g,key)
	end
end

level.keyreleased = function(g,l,key)
	game.state.run(g.name,"level","keyreleased",g,l,key)

	if _G[Enums.games.levels[g.name][l.t]]["keyreleased"] then
		_G[Enums.games.levels[g.name][l.t]]["keyreleased"](g,key)
	end
end

level.gamepadpressed = function(g,l,button)
	game.state.run(g.name,"level","gamepadpressed",g,l,button)

	if _G[Enums.games.levels[g.name][l.t]]["gamepadpressed"] then
		_G[Enums.games.levels[g.name][l.t]]["gamepadpressed"](g,l,button)
	end
end

level.draw = function(g,l)
	game.state.run(g.name,"level","draw",g,l)

	if _G[Enums.games.levels[g.name][l.t]]["draw"] then
		_G[Enums.games.levels[g.name][l.t]]["draw"](g,l)
	end
end

return level