local function make(a,c,size,spr,hp)
	a.cinit=c or EC.dark_green
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 49
	a.hp=hp or 8

	a.value=1

	--module.make(a,EM.controller,EMC.aim,EMC.aims.ai_shoot_accurate,Player)
	--module.make(a,EM.controller,EMC.action,EMC.actions.topdown_ai_action,Player)
	module.make(a,EM.hit,3,6,EC.white)
	module.make(a,EM.tail,a.cinit,9)
	--module.make(a,EM.inventory,1)
	--table.insert(a.inventory,actor.make(EA[Enums.games[Game.t]].machinegun,a.x,a.y,0,0,a.cinit,EC.green))
	module.make(a,EM.animation,EM.animations.frames,10,2)
	module.make(a,EM.hitradius,4)
	module.make(a,EM.drop,"coin")
	a.flags=flags.set(a.flags,EF.character,EF.bouncy,EF.enemy,EF.damageable, EF.shootable, EF.explosive)

	a.d=math.choose(math.pi)
	a.vel=1
	a.rage=0
end

local function control(a)
	a.rage=math.floor(Game.score/5)
	a.c=a.cinit+a.rage
	if Player.hp<=0 then
		for i,v in ipairs(Game.actors) do
			if flags.get(v.flags,EF.enemy) then
				if v~=a then
					--a.controller.aim.target=v
				end
			end
		end
	end
end

local function draw(a)

end

return
{
	make = make,
	control = control,
	draw = draw,
}