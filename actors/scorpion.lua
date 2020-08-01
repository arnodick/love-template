local function make(g,a,c,size,spr,hp)
	a.cinit=c or "dark_blue"
	a.c=a.cinit or "blue"
	a.size=size or 1
	a.spr=spr or 81
	a.hp=hp or 8

	module.make(a,EM.sound,4,"damage")
	module.make(a,EM.animation,EM.animations.frames,10,2)
	module.make(a,EM.hitradius,4)
	module.make(a,EM.tail,a.cinit,9)
	module.make(a,EM.inventory,2)
	a.flags=flags.set(a.flags,EF.character,EF.damageable,EF.shootable,EF.explosive)

	--animation.make(a,2,32) --SWEET GLITCH ANIMATION
end

return
{
	make = make,
}