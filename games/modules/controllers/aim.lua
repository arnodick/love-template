local function make(a,c)
	c.aimhorizontal=0
	c.aimvertical=0
	c.shoot=false
	c.action=false
end

local function control(a,c,gs)
	if _G[EMC.aims[c.st]]["control"] then
		_G[EMC.aims[c.st]]["control"](a,c)
	end

	if a.inventory then
		if #a.inventory>0 then
			item.use(a.inventory[1],gs,a,c.aimhorizontal,c.aimvertical,c.shoot)
		end
	end
end

return
{
	make = make,
	control = control,
}