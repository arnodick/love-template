local function make(l)
	local ea=Enums.actors
	actor.make(ea.effect,ea.effects.wiper,0,5)
	local port=actor.make(ea.effect,ea.effects.portal,Game.width/2,Game.height/2)
	port.c=Enums.colours.red
	actor.make(ea.item,ea.items.hammer,Game.width/2-40,Game.height/2)
end

local function control(l)

end

return
{
	load = load,
	make = make,
	control = control,
}