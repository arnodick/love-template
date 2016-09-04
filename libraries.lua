--loads all the library.lua files you've made
--it's dynamic ie if you put a library.lua file in the working directory it will load it into the game automatically
local function load()
	local files = love.filesystem.getDirectoryItems("") --get all the files+directories in working dir
	for i = #files,1,-1 do --decrements bc had to delete files from a table before
		if love.filesystem.isFile(files[i]) then --if it isn't a directory
			local filedata = love.filesystem.newFileData("code", files[i])
			local filename = filedata:getFilename() --get the file's name
			if filedata:getExtension() == "lua" --if it's a lua file and isn't a reserved file
			and filename ~= "conf.lua"
			and filename ~= "main.lua" then --it's a library, so include it
				filename = string.gsub(filename, ".lua", "")
				_G[filename] = require(filename)
			end
		end
	end
end

return
{
	load = load,
}