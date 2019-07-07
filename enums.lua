local function load(dir,...)
	local e={}
	local dirstoread={...}
	local filesindir = love.filesystem.getDirectoryItems(dir)
	for i,fileordir in pairs(filesindir) do
		if dir~="" then --just to make subfolders have the proper syntax
			fileordir=dir.."/"..fileordir
		end
		local fileinfo=love.filesystem.getInfo(fileordir)
		if fileinfo.type=="file" then--if file isn't a directory
			local filedata = love.filesystem.newFileData("code", fileordir)
			local filename = filedata:getFilename()
			local enumdir=false
			for j=1,#dirstoread do
				if dir~="" or dir==dirstoread[j] then
					enumdir=true
				end
			end
			if enumdir then
				local enumname=string.gsub(filename, ".*/", "")--gets rid of any directory strings in filename ie: actors/dog.lua becomes dog.lua
				enumname=string.gsub(enumname, ".lua", "")
				table.insert(e,enumname)
				e[enumname]=#e
			end
		elseif fileinfo.type=="directory" then--if file is a folder
			local enumname=string.gsub(fileordir, ".*/", "")--gets rid of any directory strings in filename ie: actors/dog.lua becomes dog.lua
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
	return e
end

local function constants(e) --NOTE this function has side effects! makes global variables
	--if e.games then
		--TODO here is where change to EA=e.actors
		if e.actors then
			EA=e.actors
		end
	--end
	if e.modules then
		EM=e.modules
		if EM.menus then
			EMM=EM.menus
		end
		if EM.controllers then
			EMC=EM.controllers
			if EMC.inputs then
				EMCI=EMC.inputs
			end
		end

	end
	e.flags=flags.load()
	EF=e.flags
	LG=love.graphics
end

return
{
	load = load,
	constants = constants,
}