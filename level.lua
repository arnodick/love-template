local level={}
local modes={}

level.load = function (g,dir)
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

level.make = function (g,index)
	local gamename=g.name
	local l={}
	local lt=Enums.games.levels[gamename.."_level"]

	--calls the game's general level code ie: offgrid_level.lua
	if _G[Enums.games.levels[lt]]["make"] then
		_G[Enums.games.levels[lt]]["make"](g,l,index)
	end

	--calls the level's specific type code ie: city.lua
	if _G[Enums.games.levels[gamename][l.t]]["make"] then
		_G[Enums.games.levels[gamename][l.t]]["make"](g,l)
	end

	g.levels.current=l
end

level.control = function (g,l)
	local gamename=g.name
	local lt=Enums.games.levels[gamename.."_level"]

	if _G[Enums.games.levels[lt]]["control"] then
		_G[Enums.games.levels[lt]]["control"](g,l)
	end

	if _G[Enums.games.levels[gamename][l.t]]["control"] then
		_G[Enums.games.levels[gamename][l.t]]["control"](g,l)
	end
	if l.transition then
		transition.control(l,l.transition)
	end
end

level.keypressed = function (g,l,key)
	local gamename=g.name
	local lt=Enums.games.levels[gamename.."_level"]

	if _G[Enums.games.levels[lt]]["keypressed"] then
		_G[Enums.games.levels[lt]]["keypressed"](g,l,key)
	end

	if _G[Enums.games.levels[gamename][l.t]]["keypressed"] then
		_G[Enums.games.levels[gamename][l.t]]["keypressed"](g,key)
	end
end

level.keyreleased = function (g,l,key)
	local gamename=g.name
	local lt=Enums.games.levels[gamename.."_level"]

	if _G[Enums.games.levels[lt]]["keyreleased"] then
		_G[Enums.games.levels[lt]]["keyreleased"](g,l,key)
	end

	if _G[Enums.games.levels[gamename][l.t]]["keyreleased"] then
		_G[Enums.games.levels[gamename][l.t]]["keyreleased"](g,key)
	end
end

level.gamepadpressed = function (g,l,button)
	local gamename=g.name
	local lt=Enums.games.levels[gamename.."_level"]

	if _G[Enums.games.levels[lt]]["gamepadpressed"] then
		_G[Enums.games.levels[lt]]["gamepadpressed"](g,l,button)
	end

	if _G[Enums.games.levels[gamename][l.t]]["gamepadpressed"] then
		_G[Enums.games.levels[gamename][l.t]]["gamepadpressed"](g,l,button)
	end
end

level.draw = function (g,l)
	local gamename=g.name
	local lt=Enums.games.levels[gamename.."_level"]

	if _G[Enums.games.levels[lt]]["draw"] then
		_G[Enums.games.levels[lt]]["draw"](g,l)
	end

	if _G[Enums.games.levels[gamename][l.t]]["draw"] then
		_G[Enums.games.levels[gamename][l.t]]["draw"](g,l)
	end
end

return level