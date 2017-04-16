local function make(l)
	actor.make(EA.effect,EA.effects.wiper,0,5)

	local i1=actor.make(EA.collectible,EA.collectibles.hp,Game.width/2-40,Game.height/2-40)
	i1.flags=flags.set(i1.flags,EF.shopitem)
	i1.menu=menu.make(EM.text,i1.x,i1.y,24,24,"$"..i1.cost,EC.white,EC.dark_gray)
	local m=i1.menu
	border.make(m,m.x,m.y,m.w,m.h,EC.white,EC.dark_gray)

	local i2=actor.make(EA.item,EA.items.hammer,Game.width/2,Game.height/2-40,0,0,EC.dark_purple,EC.dark_purple,true)--TODO put gun colour AFTER shopitem
	i2.menu=menu.make(EM.text,i2.x,i2.y,24,24,"$"..i2.cost,EC.white,EC.dark_gray)
	local m=i2.menu
	border.make(m,m.x,m.y,m.w,m.h,EC.white,EC.dark_gray)

	local i3=actor.make(EA.collectible,EA.collectibles.key,Game.width/2+40,Game.height/2-40)
	i3.flags=flags.set(i3.flags,EF.shopitem)
	i3.menu=menu.make(EM.text,i3.x,i3.y,24,24,"$"..i3.cost,EC.white,EC.dark_gray)
	local m=i3.menu
	border.make(m,m.x,m.y,m.w,m.h,EC.white,EC.dark_gray)
end

local function control(l)

end

return
{
	load = load,
	make = make,
	control = control,
}