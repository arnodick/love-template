local function make(a,c)
	c.movehorizontal=0
	c.movevertical=0
end

local function control(a,c,gs)
	if _G[ECT.moves[c.st]]["control"] then
		_G[ECT.moves[c.st]]["control"](a,c)
	end
end

return
{
	make = make,
	control = control,
}