local library={}

--given a folder and a file type, recursively loads all the files of that type from the folder and its subfolders into the game
--json files have all their data, tables and values, loaded into a table
--jpg files are load into a table of images
--lua files are included as code libraries
library.load = function(dir,ext)
	ext=ext or "json"--default to json bc most other file types are usually only loaded at startup
	local l={}--make a table to put the loaded stuff into (this is unused when loading lua files)
	local files=love.filesystem.getDirectoryItems(dir)
	for i,v in ipairs(files) do
		local filedata=love.filesystem.newFileData("code", v) --gets each file's filedata, so we can determine their extensions and names
		local filename=filedata:getFilename() --get the file's name
		local filepath=filename--start building the diectory path to the file
		if dir~="" then--if this is the first iteration, leave the filepath un-prepended
			filepath=dir.."/"..filename--otherwise, prepend the filename with the dir
		end
		if love.filesystem.isFile(filepath) then--if file isn't a directory
			if filedata:getExtension()==ext then--and it has the extension we are looking for
				local f=string.gsub(filename, "."..ext, "")--strip the file extension so we can use the result as a key in the table to be returned
				if tonumber(f) then--if the filename (without extension) is a number then index the file in the table by integer
					f=tonumber(f)
				end
				if ext=="json" then
					l[f]=json.load(filepath)--load json data into the table
				elseif ext=="jpg" then
					l[f]=LG.newImage(filepath)--load image objects into the table
				elseif ext=="lua" --if it's a lua file and isn't a reserved file
				and filename~=".git"
				and filename~="conf.lua"
				and filename~="main.lua" then --it's a library, so include it
					filepath=string.gsub(filepath, "."..ext, "")--strip the extension from the filepath, because require does not REQUIRE them ( hah hah hah (: )
					_G[f]=require(filepath)--load the library into lua
				end
			end
		elseif love.filesystem.isDirectory(filepath) then--if file is a folder
			if filepath~=".git" then--TODO does this actually work?
				l[filename]=library.load(filepath,ext)--start a new iteration of recursion on the folder, passing in the filepath we built earlier in this iteration
			end
		end
	end
	return l
end

return library