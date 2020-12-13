local function make(g,a,c,size,spr,hp)
	a.cinit=c or "yellow"
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 97
	a.hp=hp or 16

	a.value=1
	a.speed=2

	module.make(g,a,EM.target,g.player)

	module.make(g,a,EM.controller,EMC.move,EMCI.ai,a.x,a.y)
	module.make(g,a,EM.sound,3,"damage")
	module.make(g,a,EM.animation,EM.animations.frames,10,2)
	module.make(g,a,EM.hitradius,4)
	a.flags=flags.set(a.flags,EF.character,EF.enemy,EF.damageable, EF.shootable, EF.explosive)

	--g.level.enemies.max=math.clamp(g.level.enemies.max+1,1,g.level.enemies.maxlimit)
	g.level.enemycount.max=math.clamp(g.level.enemycount.max+1,1,g.level.enemycount.maxlimit)
end

local function control(g,a)
	if love.math.random(10000)==1 then
		--actor.load(g,"hp",a.x,a.y)
----[[
		local smolhp=actor.make(g,EA.hp,a.x,a.y,0,0,"red",1,129)
		smolhp.value=1
		smolhp.scalex=0.5
		smolhp.scaley=0.5
--]]
	end

	local mindist=100
	local movedist=vector.distance(a.x,a.y,a.controller.move.target.x,a.controller.move.target.y)

	if a.target then--if you aren't running to safety
		local playerdist=vector.distance(a.x,a.y,a.target.x,a.target.y)
		if playerdist<mindist then--if player is too close and you're cornered, then run to safety
			if a.x>g.level.map.width-32 or a.x<32 or a.y>g.level.map.height-32 or a.y<32 then
				a.controller.move.target.x,a.controller.move.target.y=love.math.random(g.level.map.width-32),love.math.random(g.level.map.height-32)
				local targetdist=vector.distance(a.controller.move.target.x,a.controller.move.target.y,a.target.x,a.target.y)
				while targetdist<mindist do
					a.controller.move.target.x,a.controller.move.target.y=love.math.random(g.level.map.width-32),love.math.random(g.level.map.height-32)
					targetdist=vector.distance(a.controller.move.target.x,a.controller.move.target.y,a.target.x,a.target.y)
				end
				a.target=nil--don't worry about player any more, just get to safety
			else--if player is too close and you're not cornered, BACK OFF
				local playerdir=vector.direction(a.target.x,a.target.y,a.x,a.y)--meant to be backwards so squid goes away
				a.controller.move.target.x,a.controller.move.target.y=a.x+(math.cos(playerdir)*playerdist),a.y+(math.sin(playerdir)*playerdist)
			end
		else--if player is not close, then random jitter
			local x,y=love.math.random(g.level.map.width),love.math.random(g.level.map.height)
			local randdist=vector.distance(x,y,a.target.x,a.target.y)
			while randdist<mindist do
				x,y=love.math.random(g.level.map.width),love.math.random(g.level.map.height)
				randdist=vector.distance(x,y,a.target.x,a.target.y)
			end
			a.controller.move.target.x,a.controller.move.target.y=x,y
		end
	elseif movedist<=a.vel then--if you've made it to safety then look out for player again
		module.make(g,a,EM.target,g.player)
	end
end

return
{
	make = make,
	control = control,
}