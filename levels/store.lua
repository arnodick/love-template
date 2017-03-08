local function make(l)
	local ea=Enums.actors
	local ec=Enums.colours
	actor.make(ea.effect,ea.effects.wiper,0,5)
	local port=actor.make(ea.effect,ea.effects.portal,Game.width/2,Game.height/2)
	port.c=Enums.colours.red
	local i1=actor.make(ea.collectible,ea.collectibles.hp,Game.width/2-40,Game.height/2-40)
	i1.flags=flags.set(i1.flags,Enums.flags.shopitem)
	i1.menu=menu.make(i1.x,i1.y,24,24,"$1",ec.white,ec.dark_gray,ec.white,ec.dark_gray)
end

local function control(l)

end

return
{
	load = load,
	make = make,
	control = control,
}