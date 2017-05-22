local function make(a,c,size,spr,hp)
	a.cinit=c or EC.yellow
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 97
	a.hp=hp or 16
	controller.make(a,ECT.move,ECT.moves.ai_target_avoid,Player)
	
	module.make(a,EM.hit,3,6,EC.white)

	a.value=1
	a.speed=2

	module.make(a,EM.animation,EM.animations.frames,10,2)
	module.make(a,EM.hitradius,4)
	a.flags=flags.set(a.flags,EF.character,EF.enemy,EF.damageable, EF.shootable, EF.explosive)

	Game.levels.current.enemies.max=math.clamp(Game.levels.current.enemies.max+1,1,Game.levels.current.enemies.maxlimit)
end

local function control(a)
	if love.math.random(10000)==1 then
		local smolhp=actor.make(EA.hp,a.x,a.y,0,0,EC.red,1,129)
		smolhp.value=1
		smolhp.scalex=0.5
		smolhp.scaley=0.5
	end
end

local function dead(a)

end

return
{
	make = make,
	control = control,
	dead = dead,
}