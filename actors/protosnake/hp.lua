local function make(a,c,size,spr)
	a.cinit=c or EC.red
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 129
	a.sprinit=a.spr

	module.make(a,EM.collectible)

	a.getsfx=6--TODO just call this sfx? or snd
	a.cost=2
	a.value=4
end

local function control(a,gs)

end

return
{
	make = make,
	control = control,
}