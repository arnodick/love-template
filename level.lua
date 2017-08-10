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

local function make(g,lindex)
	local gamename=g.name

	if lindex~=g.levelpath[#g.levelpath] then
		table.insert(g.levelpath,lindex)
	end
	local lload=g.levels[lindex]
	local l={}
	l.t=Enums.games.levels[gamename][lload.values.t]
	l.c=lload.values.c
	l.enemies={}
	for i,v in pairs(lload.enemies) do
		if type(i)=="number" then
			l.enemies[i]=EA[g.name][v]
		else
			l.enemies[i]=v
		end
	end

	l.actordrops=lload.actordrops
	l.portal1=lload.portal1
	l.portal2=lload.portal2
	l.portalstore=lload.portalstore

	l.storeitem1=lload.storeitem1
	l.storeitem2=lload.storeitem2
	l.storeitem3=lload.storeitem3

	for i=1,l.enemies.max do
		actor.make(l.enemies[1])
	end

	l.spawnindex=1

	if _G[Enums.games.levels[gamename][l.t]]["make"] then
		_G[Enums.games.levels[gamename][l.t]]["make"](l,gs)
	end
	return l
end

local function control(g,l)
	local gamename=g.name
	local enemycount=g.counters.enemy
	
	if enemycount<l.enemies.max then
		actor.make(EA[g.name].spawn)
	end

	if _G[Enums.games.levels[gamename][l.t]]["control"] then
		_G[Enums.games.levels[gamename][l.t]]["control"](l,gs)
	end
end

return
{
	load = load,
	make = make,
	control = control,
}