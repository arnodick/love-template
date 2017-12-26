local function make(a,c,size,spr)
	a.cinit=c or EC.blue
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 177
	a.sprinit=a.spr

	module.make(a,EM.collectible)
	module.make(a,EM.sound,6,"get")

	a.cost=0
end

local function get(g,a)
	local port=actor.make(g,EA[g.name].portal,g.width/2,g.height/2+40)
	port.c=EC.red
	port.level=2
end

return
{
	make = make,
	get = get,
}