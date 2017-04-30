local function make(l)
	actor.make(EA.wiper,0,5)

	for i=1,3 do
		local storeitem=l["storeitem"..i]
		if storeitem then
			local dropname=storeitem.drop
			local x=Game.width/2-40+(i-1)*40
			local drop=actor.make(EA[dropname],x,Game.height/2-40)
			drop.flags=flags.set(drop.flags,EF.shopitem)
			drop.menu=menu.make(EM.text,drop.x,drop.y,24,24,"$"..drop.cost,EC.white,EC.dark_gray)
			local m=drop.menu
			border.make(m,m.x,m.y,m.w,m.h,EC.white,EC.dark_gray)
		end
	end
--[[
	local i1=actor.make(EA.hp,Game.width/2-40,Game.height/2-40)
	i1.flags=flags.set(i1.flags,EF.shopitem)
	i1.menu=menu.make(EM.text,i1.x,i1.y,24,24,"$"..i1.cost,EC.white,EC.dark_gray)
	local m=i1.menu
	border.make(m,m.x,m.y,m.w,m.h,EC.white,EC.dark_gray)

	local i2=actor.make(EA.hammer,Game.width/2,Game.height/2-40,0,0,EC.dark_purple)
	i2.flags=flags.set(i2.flags,EF.shopitem)
	i2.menu=menu.make(EM.text,i2.x,i2.y,24,24,"$"..i2.cost,EC.white,EC.dark_gray)
	local m=i2.menu
	border.make(m,m.x,m.y,m.w,m.h,EC.white,EC.dark_gray)

	local i3=actor.make(EA.key,Game.width/2+40,Game.height/2-40)
	i3.flags=flags.set(i3.flags,EF.shopitem)
	i3.menu=menu.make(EM.text,i3.x,i3.y,24,24,"$"..i3.cost,EC.white,EC.dark_gray)
	local m=i3.menu
	border.make(m,m.x,m.y,m.w,m.h,EC.white,EC.dark_gray)
--]]
end

local function control(l)

end

return
{
	load = load,
	make = make,
	control = control,
}