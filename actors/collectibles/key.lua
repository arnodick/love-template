local function make(a,c,size,spr)
	a.cinit=c or Enums.colours.blue
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 177
	a.sprinit=a.spr

	a.getsfx=6--TODO just call this sfx? or snd
	a.cost=0
end

local function control(a,gs)

end

local function get(a)
	local ea=Enums.actors
	local port=actor.make(ea.effect,ea.effects.portal,Game.width/2,Game.height/2+40)
	port.c=Enums.colours.red
end

return
{
	make = make,
	control = control,
	get = get,
}