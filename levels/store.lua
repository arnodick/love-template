local function make(l)
	actor.make(EA.wiper,0,5)

	for i=1,3 do
		local storeitem=l["storeitem"..i]
		if storeitem then
			local dropname=storeitem.drop
			local x=Game.width/2-40+(i-1)*40
			local drop=actor.make(love.math.random(#EA),x,Game.height/2-40)
			--local drop=actor.make(EA[dropname],x,Game.height/2-40)
			drop.flags=flags.set(drop.flags,EF.shopitem)
			local cost=0
			if drop.cost then
				cost=drop.cost
			end
			drop.menu=menu.make(EM.text,drop.x,drop.y,24,24,"$"..cost,EC.white,EC.dark_gray)--TODO put costs option in inis
			local m=drop.menu
			border.make(m,m.x,m.y,m.w,m.h,EC.white,EC.dark_gray)
		end
	end
end

local function control(l)

end

return
{
	load = load,
	make = make,
	control = control,
}