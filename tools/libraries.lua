--loads all the library.lua files you've made
--it's dynamic ie if you put a library.lua file in the working directory it will load it into the game automatically
local function load(dir,ext)
	local files = love.filesystem.getDirectoryItems(dir) --get all the files+directories in working dir
	for i=1,#files do --decrements bc had to delete files from a table before
		local filepath=files[i]
		if dir~="" then--if this is not first iteration through recursion
			filepath=dir.."/"..files[i]--prefix filename with parent path directories
		end
		if love.filesystem.isFile(filepath) then --if it isn't a directory
			local filedata = love.filesystem.newFileData("code", filepath)--used to get file name and extension
			local filename = filedata:getFilename() --get the file's name
			if filedata:getExtension() == "lua" --if it's a lua file and isn't a reserved file
			and filename ~= "conf.lua"
			and filename ~= "main.lua" then --it's a library, so include it
				filename = string.gsub(filename, ".lua", "")--get rid of the .lua extension in the filename so we can store it as table key in _G
				local globalname = string.gsub(filename, ".*/", "") --get rid of prefix folder path, bc global name cannot be "actors/actor", must be just "actor"
				_G[globalname] = require(filename)--load the library into lua
			end
		elseif love.filesystem.isDirectory(filepath) then --if it's a dir, then recursively load any .lua files in there
			if filepath~=".git" then--TODO does this actually work?
				libraries.load(filepath)
			end
		end
	end
end

return
{
	load = load,
}