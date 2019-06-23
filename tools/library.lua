local library={}

--given a folder and a file type, recursively loads all the files of that type from the folder and its subfolders into the game
--json files have all their data, tables and values, loaded into a table
--pngs are loaded as sprite tables including a spritesheet and quads
--jpg files are load into a table of images
--lua files are included as code libraries
library.load = function(dir,...)
	--TODO make this take multiple ext for ogg and wav ie?
	local ext={...}--ext can be a table containing multiple extensions
	if #ext==1 then--if ext only has one value, make it into a string equal to the one value
		ext=ext[1]
	elseif #ext==0 then--if empty, ext defaults to "json" bc most other file types are usually only loaded at startup so aren't used as much as json
		 ext = "json"
	end
	local l={}--make a table to put the loaded stuff into (this is unused when loading lua files)
	local files=love.filesystem.getDirectoryItems(dir)
	for i,v in ipairs(files) do
		--TODO do we need to specify contents as "sound" or whatever? what does this ("code") even do?
		local filedata=love.filesystem.newFileData("code", v) --gets each file's filedata, so we can determine their extensions and names
		local filename=filedata:getFilename() --get the file's name
		local filepath=filename--start building the diectory path to the file
		if dir~="" then--if this is the first iteration, leave the filepath un-prepended
			filepath=dir.."/"..filename--otherwise, prepend the filename with the dir
		end
		if love.filesystem.isFile(filepath) then--if file isn't a directory
			local fileext=filedata:getExtension()
			if type(ext)=="table" then--if we want to load multiple different types of files (eg wav or ogg)
				if supper.contains(ext,fileext) then
					if fileext=="ogg" or fileext=="wav" then
						print(filename.. " is a wav or ogg")
						local soundfx={}
						-- if positional then
						-- 	soundfx.source=love.sound.newSoundData("sfx/"..filename)
						-- 	table.insert(s,love.sound.newSoundData("sfx/"..filename))
						-- else
							soundfx.source=love.audio.newSource(dir.."/"..filename,"static")
							soundfx.pitchoffs=0
							table.insert(l,soundfx)
							supper.print(soundfx)
						-- end
					end
				end
			elseif type(ext)=="string" then
				if ext==fileext then--and it has the extension we are looking for
					local f=string.gsub(filename, "."..ext, "")--strip the file extension so we can use the result as a key in the table to be returned
					if tonumber(f) then--if the filename (without extension) is a number then index the file in the table by integer
						f=tonumber(f)
					end
					if ext=="json" then
						l[f]=json.load(filepath)--load json data into the table
					elseif ext=="jpg" then
						l[f]=LG.newImage(filepath)--load image objects into the table
					elseif ext=="wav" then
						l[f]=love.audio.newSource(filepath,"static")
						l[f]:setLooping(true)
					elseif ext=="png" then
						-- print(i) print(f)--i and f should always be the same but if there are extra files in gfx folder i can be wrong
						l[f]=sprites.load(filepath,f)--for now sprites files have to be named with integer ie 1.png
					elseif ext=="lua" --if it's a lua file and isn't a reserved file
					and filename~=".git"--TODO does this do anything or work?
					and filename~="conf.lua"
					and filename~="main.lua" then --it's a library, so include it
						filepath=string.gsub(filepath, "."..ext, "")--strip the extension from the filepath, because require does not REQUIRE them ( hah hah hah (: )
						_G[f]=require(filepath)--load the library into lua
					end
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