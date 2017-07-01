local function make(a,c,size,spr,hp)
	a.cinit=c or EC.yellow
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 97
	a.hp=hp or 16

	a.value=1
	a.speed=2

	module.make(a,EM.target,Player)

	module.make(a,EM.controller,EMC.move,EMI.ai,a.x,a.y)
	module.make(a,EM.hit,3,6,EC.white)
	module.make(a,EM.animation,EM.animations.frames,10,2)
	module.make(a,EM.hitradius,4)
	a.flags=flags.set(a.flags,EF.character,EF.enemy,EF.damageable, EF.shootable, EF.explosive)

	Game.levels.current.enemies.max=math.clamp(Game.levels.current.enemies.max+1,1,Game.levels.current.enemies.maxlimit)
end

local function control(a)
	if love.math.random(10000)==1 then
		local smolhp=actor.make(EA[Enums.games[Game.t]].hp,a.x,a.y,0,0,EC.red,1,129)
		smolhp.value=1
		smolhp.scalex=0.5
		smolhp.scaley=0.5
	end

	local mindist=100
	local movedist=vector.distance(a.x,a.y,a.controller.move.target.x,a.controller.move.target.y)

	if a.target then--if you aren't running to safety
		local playerdist=vector.distance(a.x,a.y,a.target.x,a.target.y)
		if playerdist<mindist then--if player is too close and you're cornered, then run to safety
			if a.x>Game.width-32 or a.x<32 or a.y>Game.height-32 or a.y<32 then
				a.controller.move.target.x,a.controller.move.target.y=love.math.random(Game.width),love.math.random(Game.height)
				local targetdist=vector.distance(a.controller.move.target.x,a.controller.move.target.y,a.target.x,a.target.y)
				while targetdist<mindist do
					a.controller.move.target.x,a.controller.move.target.y=love.math.random(Game.width),love.math.random(Game.height)
					targetdist=vector.distance(a.controller.move.target.x,a.controller.move.target.y,a.target.x,a.target.y)
				end
				a.target=nil--don't worry about player any more, just get to safety
			else--if player is too close and you're not cornered, BACK OFF
				local playerdir=vector.direction(vector.components(a.x,a.y,a.target.x,a.target.y))
				a.controller.move.target.x,a.controller.move.target.y=a.x-(math.cos(playerdir)*playerdist),a.y-(math.sin(playerdir)*playerdist)
			end
		else--if player is not close, then random jitter
			local x,y=love.math.random(Game.width),love.math.random(Game.height)
			local randdist=vector.distance(x,y,a.target.x,a.target.y)
			while randdist<mindist do
				x,y=love.math.random(Game.width),love.math.random(Game.height)
				randdist=vector.distance(x,y,a.target.x,a.target.y)
			end
			a.controller.move.target.x,a.controller.move.target.y=x,y
		end
	elseif movedist<=a.vel then--if you've made it to safety then look out for player again
		module.make(a,EM.target,Player)
	end
end

return
{
	make = make,
	control = control,
}