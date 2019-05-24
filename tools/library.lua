local library={}

--loads all the library.lua files you've made
--it's dynamic ie if you put a library.lua file in the working directory it will load it into the game automatically
--[[
library.load = function(dir,ext)
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
				-- l[globalname] = require(filename)--load the library into lua
			end
		elseif love.filesystem.isDirectory(filepath) then --if it's a dir, then recursively load any .lua files in there
			if filepath~=".git" then--TODO does this actually work?
				library.load(filepath)
			end
		end
	end
end
--]]
---[[
--TODO this whole thing isn't really working. instead, return all them, THEN require() them? this way can have return and require processing
--l[globalname]=f returned from filter or whatever WE call it, then foreach i,v in l do _G = require(f)

library.load = function(dir,ext)
	ext=ext or "json"
	local l={}
	local files=love.filesystem.getDirectoryItems(dir)
	print("HAPPENED")
	-- for i=1,#files do--through all files and dirs
	for i,v in ipairs(files) do--through all files and dirs
		-- local filedata=love.filesystem.newFileData("code", files[i]) --gets each file's filedata, so we can determine their extensions
		local filedata=love.filesystem.newFileData("code", v) --gets each file's filedata, so we can determine their extensions
		local filename=filedata:getFilename() --get the file's name
		local filepath=filename
		if dir~="" then
			filepath=dir.."/"..filename
		end
		print("FILEPATH "..filepath)
		-- local filepath=dir.."/"..filename
		if love.filesystem.isFile(filepath) then --if it isn't a directory
			print("IS FILE "..filepath)
			if filedata:getExtension()==ext then
				print("IS EXT "..filepath)
				local f=string.gsub(filename, "."..ext, "")--strip the file extension
				if tonumber(f) then--if the filename (without extension) is a number then index the file in the table by integer
					f=tonumber(f)
				end
				print("FILENAME "..filename)
				if ext=="json" then
					l[f]=json.load(filepath)
				elseif ext=="jpg" then
					l[f]=LG.newImage(filepath)
				elseif ext=="lua" --if it's a lua file and isn't a reserved file
				and filename~=".git"
				and filename~="conf.lua"
				and filename~="main.lua" then --it's a library, so include it
					print("f "..f)
					local globalname=string.gsub(f, ".*/", "") --get rid of prefix folder path, bc global name cannot be "actors/actor", must be just "actor"
					filepath=string.gsub(filepath, "."..ext, "")
					print("GLOBAL NAME "..globalname)
					_G[globalname]=require(filepath)--load the library into lua
				end
			end
		elseif love.filesystem.isDirectory(filepath) then
			if filepath~=".git" then--TODO does this actually work?
				l[filename]=library.load(filepath,ext)
			end
		end
	end
	return l
end

-- library.load = function(dir,ext)
-- 	local files = love.filesystem.getDirectoryItems(dir) --get all the files+directories in working dir
-- 	for i=1,#files do --decrements bc had to delete files from a table before
-- 		local filepath=files[i]
-- 		if dir~="" then--if this is not first iteration through recursion
-- 			filepath=dir.."/"..files[i]--prefix filename with parent path directories
-- 		end
-- 		if love.filesystem.isFile(filepath) then --if it isn't a directory
-- 			local filedata=love.filesystem.newFileData("code", filepath)--used to get file name and extension
-- 			local fileext=filedata:getExtension()
-- 			if fileext==ext then
-- 				library.process(filedata,fileext)
-- 			end
-- 		elseif love.filesystem.isDirectory(filepath) then --if it's a dir, then recursively load any .lua files in there
-- 			if filepath~=".git" then--TODO does this actually work?
-- 				library.load(l,filepath,ext)
-- 			end
-- 		end
-- 	end
-- end

return library