local function make(a,c)
	c.horizontal=0
	c.vertical=0
end

local function control(a,c,gs,c1,c2)
	c.horizontal,c.vertical=c1,c2
end

return
{
	make = make,
	control = control,
}