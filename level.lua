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
		print(i.." = "..v)
		if type(i)=="number" then
			l.enemies[i]=Enums.actors.characters[v]
		else
			l.enemies[i]=v
		end
	end

	local ea=Enums.actors
	for i=1,l.enemies.max do
		actor.make(ea.character,l.enemies[1])
	end
	if _G[Enums.levels[l.t]]["make"] then
		_G[Enums.levels[l.t]]["make"](l,gs)
	end
	return l
end

local function control(l)
	local enemycount=Game.settings.counters.enemies
	
	if enemycount<l.enemies.max then
		actor.make(Enums.actors.effect,Enums.actors.effects.spawn)
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