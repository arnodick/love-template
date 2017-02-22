local function load(dir,...)
	--local e=LIP.load("ini/enums.ini")
	local dirstoread={...}
	local e={} 
	local enames={}
	local filesindir = love.filesystem.getDirectoryItems(dir)
	for i = #filesindir,1,-1 do
		local fileordir=filesindir[i]
		if dir~="" then --just to make subfolders have the proper syntax
			fileordir=dir.."/"..filesindir[i]
		end
		if love.filesystem.isFile(fileordir) then
			local filedata = love.filesystem.newFileData("code", fileordir)
			local filename = filedata:getFilename()
			local enumdir=false
			for j=1,#dirstoread do
				if dir==dirstoread[j] then
					enumdir=true
				end
			end
			if enumdir then
				local enumname=string.gsub(filename, ".*/", "")
				enumname=string.gsub(enumname, ".lua", "")
				table.insert(e,enumname)
				enames[enumname]=i
			end
--[[
			if filedata:getExtension() == "lua"
			and filename ~= "conf.lua"
			and filename ~= "main.lua" then
				filename = string.gsub(filename, ".lua", "")
				local globalname = string.gsub(filename, ".*/", "")
				_G[globalname] = require(filename)
			end
--]]
		elseif love.filesystem.isDirectory(fileordir) then
			local enumdir=false
			for j=1,#dirstoread do
				if filesindir[i]==dirstoread[j] then
					enumdir=true
				end
			end
			if enumdir then
				--local etemp=enums.load(fileordir,...)
				--table.insert(e,etemp)
				e[fileordir]=enums.load(fileordir,...)
				--print("Dir = "..fileordir)
			end
		end
	end
	return e
end

return
{
	load = load,
}