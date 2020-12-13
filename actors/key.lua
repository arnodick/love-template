local function make(g,a,c,size,spr)
	a.cinit=c or "blue"
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 177
	a.sprinit=a.spr

	module.make(g,a,EM.collectible)
	module.make(g,a,EM.sound,6,"get")

	a.cost=0
end

local function get(g,a)
	local port=actor.make(g,EA.portal,g.level.map.width/2,g.level.map.height/2+40)
	port.c="red"
	port.level=2
end

return
{
	make = make,
	get = get,
}