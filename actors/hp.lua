local function make(g,a,c,size,spr)
	a.cinit=c or "red"
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 129
	a.sprinit=a.spr

	module.make(g,a,EM.collectible)
	module.make(g,a,EM.sound,6,"get")

	a.cost=2
	a.value=4
end

return
{
	make = make,
}