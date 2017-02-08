local function make(a,ct)
	a.ct=ct
	a.controller={0,0,0,0,0,0,false,false}
	if _G[Enums.controllernames[a.ct]]["make"] then
		_G[Enums.controllernames[a.ct]]["make"](a)
	end
end

local function update(a,gs)
	if a.controller then
		local e=Enums.buttons

		if _G[Enums.controllernames[a.ct]]["control"] then
			_G[Enums.controllernames[a.ct]]["control"](a)
		end

		local c=a.controller
		a.d=vector.direction(c[e.leftstickhorizontal],-c[e.leftstickvertical])
		a.vel=vector.length(c[e.leftstickhorizontal],c[e.leftstickvertical])

		if a.gun then
			gun.control(a.gun,gs,a,c[e.rightstickhorizontal],c[e.rightstickvertical],c[e.button1])
		end
	end
end

return--TODO add all local function to a table and return the unpacked table?
{
	make = make,
	update = update,
}