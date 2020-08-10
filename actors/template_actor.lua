local function make(g,a,c,size,spr,hp)
	local e=Enums

	a.size=size or 1
	a.spr=spr or 193
	a.hp=hp or 8

	module.make(g,a,EM.sound,4,"damage")
	module.make(g,a,EM.hitradius,4)
	module.make(g,a,EM.inventory,1)

	a.flags=flags.set(a.flags,EF.damageable,EF.shootable)
end

return
{
	make = make,
}