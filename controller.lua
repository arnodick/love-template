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
	
	for k,v in pairs(c.ct) do
		if _G[Enums.controllernames[v]]["make"] then
			_G[Enums.controllernames[v]]["make"](a)
		end
	end
end

local function update(a,gs)
	local c=a.controller
	if c then

		for k,v in pairs(c.ct) do
			if _G[Enums.controllernames[v]]["control"] then
				_G[Enums.controllernames[v]]["control"](a)
			end
		end

		if a.inv then
			if #a.inv>0 then
				item.use(a.inv[1],gs,a,c.aimhorizontal,c.aimvertical,c.shoot)
			end
		end
	end
end

return
{
	make = make,
	update = update,
}