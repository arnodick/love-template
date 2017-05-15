local function load(dir,...)
	local e={}
	if dir=="" then
		e=LIP.load("enums/enums.ini")
	end
	local dirstoread={...}
	local filesindir = love.filesystem.getDirectoryItems(dir)
	for i,fileordir in pairs(filesindir) do
		if dir~="" then --just to make subfolders have the proper syntax
			fileordir=dir.."/"..fileordir
		end
		if love.filesystem.isFile(fileordir) then
			local filedata = love.filesystem.newFileData("code", fileordir)
			local filename = filedata:getFilename()
			local enumdir=false
			for j=1,#dirstoread do
				if dir~="" or dir==dirstoread[j] then
					enumdir=true
				end
			end
			if enumdir then
				local enumname=string.gsub(filename, ".*/", "")
				enumname=string.gsub(enumname, ".lua", "")
				table.insert(e,enumname)
				e[enumname]=#e
			end
		elseif love.filesystem.isDirectory(fileordir) then
			local enumname=string.gsub(fileordir, ".*/", "")
			local enumdir=false
			for j=1,#dirstoread do
				if dir~="" or enumname==dirstoread[j] then
					enumdir=true
				end
			end
			if enumdir then
				e[enumname]=enums.load(fileordir,...)
			end
		end
	end
	enums.constants(e)
	return e
end

local function constants(e) --NOTE this function has side effects! makes global variables
	if e.actors then
		EA=e.actors
	end
	if e.colours then
		EC=e.colours
	end
	if e.flags then
		EF=e.flags
	end
	if e.controllers then
		ECT=e.controllers
	end
	if e.modules then
		EM=e.modules
		if e.modules.menus then
			EMM=e.modules.menus
		end
	end
	LG=love.graphics
	game.state=state--NOTE just a hacky way to make state functions part of game function table
end

return
{
	load = load,
	constants = constants,
}