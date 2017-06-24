local function make(a,i)
	i.movehorizontal=0
	i.movevertical=0
	i.lastvertical=0
	i.lasthorizontal=0
	if _G[EMI.moves[i.st]]["make"] then
		_G[EMI.moves[i.st]]["make"](a,i)
	end
end

local function control(a,i,gs)
	if _G[EMI.moves[i.st]]["control"] then
		_G[EMI.moves[i.st]]["control"](a,i)
	end
	i.lastvertical=i.movevertical
	i.lasthorizontal=i.movehorizontal
end

return
{
	make = make,
	control = control,
}