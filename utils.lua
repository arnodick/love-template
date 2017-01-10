local function clamp(v,mi,ma,wrap)
	wrap=wrap or false
	if not wrap then
		if v<mi then v=mi
		elseif v>ma then v=ma
		end
	else
		if v<mi then v=ma
		elseif v>ma then v=mi
		end
	end
	return v
end

local function choose(...)
	local arg={...}
	return arg[love.math.random(#arg)]
end

--loads a bunch of files that share an extension from a specific directory
--returns a table with all the directory/filenames of those files
--NOTE: unpack() the output to use it as an argument in another function
local function getfiles(dir,ext)
	local filelist = {}
	local files = love.filesystem.getDirectoryItems(dir)
	for i = #files,1,-1 do --decrements bc had to delete files from a table before
		local filedata = love.filesystem.newFileData("code", files[i])
		local filename = filedata:getFilename() --get the file's name
		if filedata:getExtension() == ext
		and filename ~= "conf.lua"
		and filename ~= "main.lua" then --it's a library, so include it
			table.insert(filelist,dir.."/"..filename)
		end
	end
	return filelist
end

local function filterfiles(folder,ext)
	local files = love.filesystem.getDirectoryItems(folder)
	for i=#files,1,-1 do
		local filedata = love.filesystem.newFileData("code", files[i])
		local filename = filedata:getFilename()
		if filedata:getExtension() ~= ext then
			table.remove(files,i)
		end
	end
	return files
end

local function counterincrement(a,i)
	--THIS FUNCTION INTENTIONALLY HAS SIDE EFFECTS
	local name=Enums.actornames[a.t]
	if Counters then
		if Counters[name] then
			Counters[name] = math.clamp(Counters[name]+i,0,99)
			if name=="enemy" then
				local enemyname=Enums.enemynames[a.st]
				if Counters[enemyname] then
					Counters[enemyname] = math.clamp(Counters[enemyname]+i,0,99)
				end
			end
		end
	end
end

local function randomfraction(n)
	return love.math.random(n*10000)/10000
end

local function drawbox(x,y,w,a)
	for i=0,3 do
		love.graphics.line(x+math.cos(a+i*0.25*math.pi*2)*w/2,y+math.sin(a+i*0.25*math.pi*2)*w/2,x+math.cos(a+(i+1)*0.25*math.pi*2)*w/2,y+math.sin(a+(i+1)*0.25*math.pi*2)*w/2)
	end
end

math.clamp = clamp
math.choose = choose
math.randomfraction = randomfraction
love.filesystem.getfiles = getfiles
love.filesystem.filterfiles = filterfiles
love.graphics.drawbox = drawbox

return
{
	counterincrement = counterincrement,
}