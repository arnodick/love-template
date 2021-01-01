local supper =
{
    _VERSION        = 'supper v1.0',
    _DESCRIPTION    = 'A collection of convenient functions to make common table tasks easier.',
    _LICENSE        = [[
Copyright (c) 2017 Ashley Pringle

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]
}

--runs the function defined by input args
--t = supper.run(gamename, {"level", "cave", "make"}, ...) will run gamename.level.cave.make(...)
--use this to run different code by varying the input of the string key args
--this means we aren't limited to static functions like gamename.level.cave.make, and so don't need if or switch logic to do something like run game.level.desert.make instead of game.level.cave.make
supper.run = function(t,args,...)--takes in a table t, a list of strings args to identify the function, and function parameters for the function that will be run
	local r=nil--if we find a function in t it will be returned as r, otherwise WE return r as nil so nothing happens
	--TODO should we just check if table here?
	if #args>0 then--if we are dealing with a table, recursively dig through it to see if it contains any tables with keys matching the string args
		local f=t[args[1]]--check if first key in args is in the table
		if f then--if it is
			table.remove(args,1)--remove it froms args
			r=supper.run(f,args,...)--check f with next key in args, get the result (either r is a function or still nil)
		end
	elseif type(t)=="function" then--if we've run out of args and t is a function instead this iteration, then pass it back up the recursion chain
		r=t(...)
	end
	if r then--if all goes well and a function was found in the table with the provided args, r will be the function that is returned and run, otherwise r is still nil, so nothing happens
		return r
	end
end

--TODO THIS IS THE ONE YOU USED IN NANOGENMO AND INFINITE ADVENTURES
--puts a table called "names" in a table t
--the "names" tables is an enumerated list of all the key strings of the members of the table
--ie: t = {desert=function(...),cave=function(...),sewer=function(...)}
--then t.names[1]="desert", t.names[2]="cave", t.names[3]="sewer"
--these names can then be used to dynamically call member functions of the table t
--[[
supper.names = function(t,names)
	names=names or "names"
	local n={}
	for k,v in pairs(t) do
		table.insert(n,k)
	end
	t[names]=n
end
--]]

--this version doesn't make a table called names
supper.names = function(t)
	local names={}
	for k,v in pairs(t) do
		table.insert(names,k)
	end
	supper.copy(t,names)
end


--takes a table t of strings indexed by integer and makes integers with the strings as keys
--ie: t = {"boss", "enemy"} becomes {"boss", "enemy", boss = 1, enemy = 2}
supper.numbers = function(t)
	for i,v in ipairs(t) do
		t[v]=i
	end
end

--gives a random entry in any integer-indexed table
supper.random = function(t)
	--TODO if you're feeling fancy, pass in a function, default it to math if nil, so can pass in love.ath if you want
	return t[love.math.random(#t)]
end

supper.contains = function(t,value)
	for i,v in ipairs(t) do
		if v==value then
			return true,i
		end
	end
	return false
end

--copies all values and tables from a source table and adds them to the target table
--a new table is NOT made, so references to the target table are not broken
--also retains any values that were in the target table before copying (unless the source table has a value with the same key, in which case the value in the target table with that key is overwritten)
supper.copy = function(target,source)
	for k,v in pairs(source) do
		if type(v)~="table" then--any value in the source that isn't a table is put in the target
			target[k]=v
		else
			target[k]={}--any table in the source is recreated in the target, then has its values and tables recursively copied
			supper.copy(target[k],v)
		end
	end
end

--prints everything in a table to console by recursively travelling through every subtable
supper.print = function(table,name,space)
	name=name or "parent"--this is printed in the first line, to identify the table
	space=space or " "--space is just included for indentation, so each recursive iteration of print is indented by its recursion depth, for readability
	if space==" " then print(name.." table = "..tostring(table)) end--only print parent table name on first iteration (when there is only one space)
	for k,v in pairs(table) do
		print(space..k.." = "..tostring(v))--print the key and value of the entry in the table
		if type(v)=="table" then
			supper.print(v,name,space.."   ")--if it is also a table, print it out as well, indented one more space
		end
	end
end

--given a folder and file type(s), recursively loads all the files of that type from the folder and its subfolders into a table
--json files have all their data, tables and values, loaded into a table
--pngs are loaded as sprite tables including a spritesheet and quads
--jpg files are load into a table of images
--lua files are included as code libraries and have their names loaded in an enum table
supper.load = function(dir,extensions,excludes)
	--extensions can be a table containing multiple strings or a single string
	if extensions==nil then--if not extension(s) provided, extensions defaults to "json" bc most other file types are usually only loaded at startup so aren't used as much as json
		extensions="json"
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
		-- local fileinfo=love.filesystem.getInfo(filepath, filtertype )--TODO do filter instead of fileext stuff below
		local fileinfo=love.filesystem.getInfo(filepath)
		if fileinfo.type=="file" then--if file isn't a directory
			local fileext=filedata:getExtension()
			if type(extensions)=="table" then--if we want to load multiple different types of files (eg wav or ogg)
				if supper.contains(extensions,fileext) then
					if fileext=="ogg" or fileext=="wav" then
						local soundfx={}
						-- if positional then
						-- 	soundfx.source=love.sound.newSoundData("sfx/"..filename)
						-- 	table.insert(s,love.sound.newSoundData("sfx/"..filename))
						-- else
							soundfx.source=love.audio.newSource(dir.."/"..filename,"static")
							soundfx.pitchoffs=0
							table.insert(l,soundfx)
							-- supper.print(soundfx)
						-- end
					end
				end
			elseif type(extensions)=="string" then
				if extensions==fileext then--and it has the extension we are looking for
					local f=string.gsub(filename, "."..extensions, "")--strip the file extension so we can use the result as a key in the table to be returned
					if tonumber(f) then--if the filename (without extension) is a number then index the file in the table by integer
						f=tonumber(f)
					end
					if extensions=="json" then
						l[f]=json.load(filepath)--load json data into the table
					elseif extensions=="jpg" then
						l[f]=LG.newImage(filepath)--load image objects into the table
					elseif extensions=="wav" then
						l[f]=love.audio.newSource(filepath,"static")
						l[f]:setLooping(true)
					elseif extensions=="png" then
						l[f]=sprites.load(filepath,f)--for now sprites files have to be named with integer ie 1.png
					elseif extensions=="lua" --if it's a lua file and isn't a reserved file
					and filename~=".git"--TODO does this do anything or work?
					and filename~="conf.lua"
					and filename~="main.lua" then --it's a library, so include it
						filepath=string.gsub(filepath, "."..extensions, "")--strip the extension from the filepath, because require does not REQUIRE them ( hah hah hah (: )
						_G[f]=require(filepath)--load the library into lua
						table.insert(l,f)--insert the name of the lua library into the table that will be returned so it is indexed by integer
						l[f]=#l--make a key in the table that will be returned out of the name of the lua library whose value is the index the name of the lua library was inserted at
					end
				end
			end
		elseif fileinfo.type=="directory" then--if file is a folder
			if filepath~=".git" then--TODO does this actually work?
				if excludes==nil or not supper.contains(excludes,filename) then--if there are folders to exclude, don't load those folders, otherwise load every folder
					l[filename]=supper.load(filepath,extensions,excludes)--start a new iteration of recursion on the folder, passing in the filepath we built earlier in this iteration
				end
			end
		end
	end
	return l
end

--creates and runs a series of coroutines
supper.coroutines={}
--takes any number of coroutines and inserts them into a table with an index counter that is used by supper.coroutines.control
supper.coroutines.make = function(...)
	local cors={...}
	cors.i=1
	return cors
end
--takes in a table of coroutines created by supper.coroutines.make and runs each one in the order they were inserted into supper.coroutines.make
--if any of the coroutines are running, returns true, and when all coroutines in the cors table are done running, returns false
supper.coroutines.control = function(cors)
	local coindex=cors.i
	if coindex<=#cors then
		coroutine.resume(cors[coindex])
		local costatus=coroutine.status(cors[coindex])
		if costatus=="dead" then
			cors.i=cors.i+1
		end
	else
		return false
	end
	return true
end

-- Supper:
-- Don't walk for your supper... RUN!

return supper