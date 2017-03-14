local function make(l)
	local ea=Enums.actors--TODO just maek these global like EA?
	local ec=Enums.colours
	actor.make(ea.effect,ea.effects.wiper,0,5)
--	local port=actor.make(ea.effect,ea.effects.portal,Game.width/2,Game.height/2+40)
--	port.c=Enums.colours.red
	local i1=actor.make(ea.collectible,ea.collectibles.hp,Game.width/2-40,Game.height/2-40)
	i1.flags=flags.set(i1.flags,Enums.flags.shopitem)
	i1.menu=menu.make(i1.x,i1.y,24,24,"$"..i1.cost,ec.white,ec.dark_gray,ec.white,ec.dark_gray)
	local i2=actor.make(ea.item,ea.items.hammer,Game.width/2,Game.height/2-40,0,0,ec.dark_purple,ec.dark_purple,true)--TODO put gun colour AFTER shopitem
	i2.menu=menu.make(i2.x,i2.y,24,24,"$"..i2.cost,ec.white,ec.dark_gray,ec.white,ec.dark_gray)
	local i3=actor.make(ea.collectible,ea.collectibles.key,Game.width/2+40,Game.height/2-40)
	i3.flags=flags.set(i3.flags,Enums.flags.shopitem)
	i3.menu=menu.make(i3.x,i3.y,24,24,"$"..i3.cost,ec.white,ec.dark_gray,ec.white,ec.dark_gray)
end

local function control(l)

end

return
{
	load = load,
	make = make,
	control = control,
}