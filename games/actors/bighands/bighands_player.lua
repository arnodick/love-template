local function make(g,a,c,size,spr,hp)
	local e=Enums

	if #g.players+1 == 1 then
		if #Joysticks>0 then
			module.make(a,EM.controller,EMC.move,EMCI.gamepad)
			module.make(a,EM.controller,EMC.aim,EMCI.gamepad)
			module.make(a,EM.controller,EMC.action,EMCI.gamepad)
		end
	else
		module.make(a,EM.controller,EMC.move,EMCI.keyboard)
		module.make(a,EM.controller,EMC.aim,EMCI.mouse)
		module.make(a,EM.controller,EMC.action,EMCI.mouse)
	end

	--a.cinit=c or EC.pure_white
	--a.c=a.cinit or EC.pure_white
	a.size=size or 1
	a.spr=spr or 193
	a.hp=hp or 8

	module.make(a,EM.sound,4,"damage")
	module.make(a,EM.hitradius,4)

	a.flags=flags.set(a.flags,EF.character,EF.persistent,EF.damageable,EF.shootable)
end

local function control(g,a)
	a.angle=-a.d+math.pi/2
	if a.vel>0 then
		if not a.animation then
			module.make(a,EM.animation,EM.animations.frames,10,4)
		end
	else
		if a.animation then
			a.animation=nil
		end
	end
end

local function draw(g,a)
	
end

local function damage(a)
	
end

local function dead(a)
	
end

return
{
	make = make,
	control = control,
	draw = draw,
	damage = damage,
	dead = dead,
}