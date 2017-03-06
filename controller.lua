local function make(a,...)
	local c={}
	c.movehorizontal=0
	c.movevertical=0
	c.aimhorizontal=0
	c.aimvertical=0
	c.shoot=false
	c.powerup=false
	c.ct={...}

	a.controller=c
	
	for i=1,#c.ct do
		if _G[Enums.controllernames[c.ct[i]]]["make"] then
			_G[Enums.controllernames[c.ct[i]]]["make"](a)
		end
	end
end

local function update(a,gs)
	local c=a.controller
	if c then
		local e=Enums.commands

		for i=1,#c.ct do
			if _G[Enums.controllernames[c.ct[i]]]["control"] then
				_G[Enums.controllernames[c.ct[i]]]["control"](a)
			end
		end

		--local c=a.controller
		if a.gun then
			--gun.control(a.gun,gs,a,c.aimhorizontal,c.aimvertical,c.shoot)
			gun.use(a.gun,gs,a,c.aimhorizontal,c.aimvertical,c.shoot)
		end
	end
end

return
{
	make = make,
	update = update,
}