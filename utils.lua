local function clamp(v,mi,ma,wrap)
	wrap=wrap or false
	if not wrap then
		if v<mi then v=mi
		elseif v>ma then v=ma
		end
	else
		--if v<mi then v=ma
		if v<mi then v=ma+1+v-mi
		elseif v>ma then v=mi-1+v-ma
		end
	end
	return v
end

local function choose(...)
	local arg={...}
	return arg[love.math.random(#arg)]
end

local function randomfraction(n)
	return love.math.random(n*10000)/10000
end

local function snap(v,inc,snapto)--TODO does this need a negative version
	if v-inc<=snapto+inc then--TODO make this addition instead of subtraction?
		return snapto
	else
		return v-inc
	end
end

--local function ease(t,duration,limit,rate)
local function ease(t,start,change,duration)
	return change * t / duration + start
	--return 1+(math.clamp(t,0,duration)/duration)*limit*rate
	--return 1+(t/duration)*limit*rate
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

local function drawbox(x,y,w,a)
	for i=0,3 do
		LG.line(x+math.cos(a+i*0.25*math.pi*2)*w/2,y+math.sin(a+i*0.25*math.pi*2)*w/2,x+math.cos(a+(i+1)*0.25*math.pi*2)*w/2,y+math.sin(a+(i+1)*0.25*math.pi*2)*w/2)
	end
end

local function printformat(text,x,y,limit,align,c1,c2,alpha)
	limit=limit or Game.width - x
	align=align or "left"
	alpha=alpha or 255
	for xoff=0,1 do
		for yoff=1,1 do
			local r,g,b=unpack(Game.palette[c2])
			LG.setColor(r,g,b,alpha)
			LG.printf(text,x+xoff,y+yoff,limit,align)

			r,g,b=unpack(Game.palette[c1])
			LG.setColor(r,g,b,alpha)
			LG.printf(text,x,y,limit,align)
		end
	end
	LG.setColor(Game.palette[EC.white])
end

math.clamp = clamp
math.choose = choose
math.randomfraction = randomfraction
math.snap = snap
math.ease = ease
love.filesystem.getfiles = getfiles
love.filesystem.filterfiles = filterfiles
love.graphics.drawbox = drawbox
love.graphics.printformat = printformat

return
{
	
}