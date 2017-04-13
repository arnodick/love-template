local function make(a,c)
	c.aimhorizontal=0
	c.aimvertical=0
	c.shoot=false
	c.powerup=false
end

local function control(a,c,gs)
	if _G[ECT.aims[c.st]]["control"] then
		_G[ECT.aims[c.st]]["control"](a,c)
	end

	if a.inv then
		if #a.inv>0 then
			item.use(a.inv[1],gs,a,c.aimhorizontal,c.aimvertical,c.shoot)
		end
	end
end

return
{
	make = make,
	control = control,
}