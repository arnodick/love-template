local function load(dir)
	local l={}
	local files = love.filesystem.getDirectoryItems(dir)
	for i=1,#files do
		local file=files[i]
		if love.filesystem.isFile(dir.."/"..file) then --if it isn't a directory
			local filedata = love.filesystem.newFileData("code", file)
			local filename = filedata:getFilename() --get the file's name
			if filedata:getExtension() == "ini" then
				local f = string.gsub(filename, ".ini", "")
				if tonumber(f) then
					l[tonumber(f)]=LIP.load(dir.."/"..filename)
				else
					l[f]=LIP.load(dir.."/"..filename)
				end
			end
		end
	end
	return l
end

local function make(lload)
	local l={}
	l.t=Enums.levels[lload.values.t]
	l.c=lload.values.c
	l.enemies={}
	for i,v in pairs(lload.enemies) do
		if type(i)=="number" then
			l.enemies[i]=EA.characters[v]
		else
			l.enemies[i]=v
		end
	end

	for i=1,l.enemies.max do
		actor.make(EA.character,l.enemies[1])
	end
	l.collectibledrops=lload.collectibledrops
	if _G[Enums.levels[l.t]]["make"] then
		_G[Enums.levels[l.t]]["make"](l,gs)
	end
	return l
end

local function control(l)
	local enemycount=Game.counters.enemy
	
	if enemycount<l.enemies.max then
		actor.make(EA.effect,EA.effects.spawn)
	end

	if _G[Enums.levels[l.t]]["control"] then
		_G[Enums.levels[l.t]]["control"](l,gs)
	end
end

return
{
	load = load,
	make = make,
	control = control,
}