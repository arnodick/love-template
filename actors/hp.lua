local function make(a,c,size,spr)
	a.cinit=c or EC.red
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 129
	a.sprinit=a.spr

	a.getsfx=6--TODO just call this sfx? or snd
	a.cost=2
	a.value=4
	a.flags=flags.set(a.flags,EA.flags.collectible)
end

local function control(a,gs)

end

return
{
	make = make,
	control = control,
}