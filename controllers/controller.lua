local function make(a,ct)
	a.ct=ct
	a.controller={0,0,0,0,false,false}
	if _G[Enums.controllernames[a.ct]]["make"] then
		_G[Enums.controllernames[a.ct]]["make"](a)
	end
end

local function update(a,gs)
	if a.controller then
		local e=Enums.commands

		if _G[Enums.controllernames[a.ct]]["control"] then
			_G[Enums.controllernames[a.ct]]["control"](a)
		end

		local c=a.controller
		a.d=vector.direction(c[e.movehorizontal],-c[e.movevertical])
		a.vel=vector.length(c[e.movehorizontal],c[e.movevertical])

		if a.gun then
			gun.control(a.gun,gs,a,c[e.aimhorizontal],c[e.aimvertical],c[e.shoot])
		end
	end
end

return--TODO add all local function to a table and return the unpacked table?
{
	make = make,
	update = update,
}