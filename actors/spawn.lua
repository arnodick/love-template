local function make(g,a,c)
	a.x=love.math.random(319)
	a.y=love.math.random(239)
	a.cinit=EC.blue
	a.c=a.cinit
	a.d=0
	a.vel=0
	a.size=60
	a.flags=flags.set(a.flags,EF.enemy)--NOTE this is to make sure a bazillion spawns don't... spawn
	a.sfx=false
	local l=g.level
	a.enemyspawn=l.spawnindex
end

local function control(g,a,gs)
	if a.sfx==false then
		if g.timer-a.delta>=20 then
			sfx.play(9)
			a.sfx=true
		end
	end

	a.size=a.size-gs
	if a.size<=0 then
		local l=g.level
		local spawnnum=a.enemyspawn

		if l.enemies[spawnnum] then
			local enemy=actor.make(g,EA[l.enemies[spawnnum]],a.x,a.y)

			--TODO make a spawn function or something that has all the drop stuff in it and put it in level load characer spawn too
			if l.actordrops then
				if l.actordrops[spawnnum] then
					module.make(enemy,EM.drop,l.actordrops[spawnnum])
				end
			end

			local p1=l.portal1
			if p1 then
				if p1.droppedby==spawnnum then
					module.make(enemy,EM.drop,"portal",1)
				end
			end

			local p2=l.portal2
			if p2 then
				if p2.droppedby==spawnnum then
					module.make(enemy,EM.drop,"portal",2)
				end
			end

			local pstore=l.portalstore
			if pstore then
				if pstore.droppedby==spawnnum then
					module.make(enemy,EM.drop,"portal","store")
				end
			end
		end

		for i=1,20 do
			local spark=actor.make(g,EA.spark,a.x,a.y)
			spark.c=EC.dark_blue
		end
		a.delete=true
	end
end

local function draw(g,a)
	LG.rectangle("line",a.x-a.size/2,a.y-a.size/2,a.size,a.size)
end

return
{
	make = make,
	control = control,
	draw = draw,
}