local function make(a,c,size,spr,hp)
	a.cinit=c or EC.red
	a.c=a.cinit
	a.size=size or 2
	a.spr=spr or 8
	a.hp=hp or 50
	controller.make(a,ECT.move,ECT.moves.ai_target_charge,Player)

	module.make(a,EM.hit,3,6,EC.white)

	a.value=1
	a.speed=1.5
	module.make(a,EM.animation,EM.animations.frames,EM.animations.frames,6,2)
	module.make(a,EM.hitradius,8)
	a.flags=flags.set(a.flags,EF.character,EF.enemy,EF.damageable, EF.shootable, EF.explosive)
end

local function control(a)
	if actor.collision(a.x,a.y,a.target.move) then
		actor.damage(a.target.move,8)
		actor.damage(a,a.hp)
	end
	if Player.hp<=0 then
		for i,v in ipairs(Game.actors) do
			if flags.get(v.flags,EF.enemy) then
				if v~=a then
					a.target.move=v
				end
			end
		end
	end
end


local function draw(a)

end

local function dead(a)
	for i=1,3 do
		actor.make(EA.coin,a.x,a.y)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
	dead = dead,
}