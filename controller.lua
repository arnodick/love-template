local function make(a,...)
	a.ct={...}
	a.controller={0,0,0,0,false,false}
	for i=1,#a.ct do
		if _G[Enums.controllernames[a.ct[i]]]["make"] then
			_G[Enums.controllernames[a.ct[i]]]["make"](a)
		end
	end
end

local function update(a,gs)
	if a.controller then
		local e=Enums.commands

		for i=1,#a.ct do
			if _G[Enums.controllernames[a.ct[i]]]["control"] then
				_G[Enums.controllernames[a.ct[i]]]["control"](a)
			end
		end
---[[
		local c=a.controller
		--a.d=vector.direction(c[e.movehorizontal],-c[e.movevertical])
		--a.vel=vector.length(c[e.movehorizontal],c[e.movevertical])
--]]

		if a.gun then
			gun.control(a.gun,gs,a,c[e.aimhorizontal],c[e.aimvertical],c[e.shoot])
		end
	end
end

return
{
	make = make,
	update = update,
}