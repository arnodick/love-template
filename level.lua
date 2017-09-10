local function load(g,dir)
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

local function make(g,index)
	local gamename=g.name
	local l={}
	local lt=Enums.games.levels[gamename.."_level"]

	if _G[Enums.games.levels[lt]]["make"] then
		_G[Enums.games.levels[lt]]["make"](g,l,index)
	end

	if _G[Enums.games.levels[gamename][l.t]]["make"] then
		_G[Enums.games.levels[gamename][l.t]]["make"](l,gs)
	end
	g.levels.current=l
end

local function control(g,l)
	local gamename=g.name
	local lt=Enums.games.levels[gamename.."_level"]

	if _G[Enums.games.levels[lt]]["control"] then
		_G[Enums.games.levels[lt]]["control"](g,l)
	end

	if _G[Enums.games.levels[gamename][l.t]]["control"] then
		_G[Enums.games.levels[gamename][l.t]]["control"](l,gs)
	end
end

local function gamepadpressed(g,l,button)
	local gamename=g.name
	local lt=Enums.games.levels[gamename.."_level"]

	if _G[Enums.games.levels[lt]]["gamepadpressed"] then
		_G[Enums.games.levels[lt]]["gamepadpressed"](g,l,button)
	end

	if _G[Enums.games.levels[gamename][l.t]]["gamepadpressed"] then
		_G[Enums.games.levels[gamename][l.t]]["gamepadpressed"](g,l,button)
	end
end

return
{
	load = load,
	make = make,
	control = control,
	gamepadpressed = gamepadpressed,
}