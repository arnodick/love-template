local function make(a,c)
	c.aimhorizontal=0
	c.aimvertical=0
end

local function control(a,c,gs)
	if _G[EMC.aims[c.st]]["control"] then
		_G[EMC.aims[c.st]]["control"](a,c)
	end
end

return
{
	make = make,
	control = control,
}