local function make(g,l,index)
	local gamename=g.name

	if index~=g.levelpath[#g.levelpath] then
		table.insert(g.levelpath,index)
	end
	local lload=g.levels[index]

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
	return l
end

local function control(g,l)
	local enemycount=g.counters.enemy
	
	if enemycount<l.enemies.max then
		actor.make(EA[g.name].spawn)
	end
end

local function draw(g,l)
	map.draw(g.map,"grid")
end

return
{
	make = make,
	control = control,
	draw = draw,
}