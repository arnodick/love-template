local function make(a,c)
	c.use=false
	c.action=false
	c.lastuse=false
	c.lastaction=false
	if _G[EMC.actions[c.st]]["make"] then
		_G[EMC.actions[c.st]]["make"](a,c)
	end
end

local function control(a,c,gs)
	if _G[EMC.actions[c.st]]["control"] then
		_G[EMC.actions[c.st]]["control"](a,c)
	end
	c.lastuse=c.use
	c.lastaction=c.action
end

return
{
	make = make,
	control = control,
}