local function make(a,c)
	a.x=love.math.random(319)
	a.y=love.math.random(239)
	a.c=EC.blue
	a.d=0
	a.vel=0
	a.size=60
	a.flags=flags.set(a.flags,EF.enemy)--NOTE this is to make sure a bazillion spawns don't... spawn
	a.sfx=false
	local l=Game.levels.current
	--a.enemyspawn=(Game.score-1)%(#l.enemies)+1
	a.enemyspawn=l.spawnindex
end

local function control(a,gs)
	if a.sfx==false then
		if Game.timer-a.delta>=20 then
			sfx.play(9)
			a.sfx=true
		end
	end

	a.size=a.size-gs
	if a.size<=0 then
		local l=Game.levels.current
		local spawnnum=a.enemyspawn

		if l.enemies[spawnnum] then
			local enemy=actor.make(EA.character,l.enemies[spawnnum],a.x,a.y)			

			if l.collectibledrops then
				if l.collectibledrops[spawnnum] then
					enemy.collectibledrop=l.collectibledrops[spawnnum]
				end
			end

			local p1=l.portal1
			if p1 then
				if p1.droppedby==spawnnum then
					enemy.collectibledrop="portal"
					enemy.collectibledroplevel=1
				end
			end

			local p2=l.portal2
			if p2 then
				if p2.droppedby==spawnnum then
					enemy.collectibledrop="portal"
					enemy.collectibledroplevel=2
				end
			end

			local pstore=l.portalstore
			if pstore then
				if pstore.droppedby==spawnnum then
					enemy.collectibledrop="portal"
					enemy.collectibledroplevel="store"
				end
			end

		end
		for i=1,20 do
			local spark=actor.make(EA.effect,EA.effects.spark,a.x,a.y)
			spark.c=EC.dark_blue
		end
		a.delete=true
	end
end

local function draw(a)
	LG.rectangle("line",a.x-a.size/2,a.y-a.size/2,a.size,a.size)
end

return
{
	make = make,
	control = control,
	draw = draw,
}