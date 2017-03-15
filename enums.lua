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
	return e
end

return
{
	load = load,
}