local function make(g,a,c,size,char,hp)
	local e=Enums

	module.make(a,EM.controller,EMC.move,EMCI.ai,10,10)

	a.cinit=c or EC.yellow
	a.c=a.cinit or EC.yellow
	a.size=size or 1
	a.char=char or "O"
	a.hp=hp or 8

	a.flags=flags.set(a.flags,EF.character,EF.persistent,EF.damageable, EF.shootable, EF.explosive)

end

local function control(g,a)

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