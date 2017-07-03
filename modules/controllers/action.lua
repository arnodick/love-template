local function make(a,c)
	c.use=false
	c.action=false
	c.lastuse=false
	c.lastaction=false
end

local function control(a,c,gs,c1,c2)
	c.lastuse=c.use
	c.lastaction=c.action
	
	c.use,c.action=c1,c2
end

return
{
	make = make,
	control = control,
}