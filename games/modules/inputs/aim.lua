local function make(a,i)
	i.horizontal=0
	i.vertical=0
end

local function control(a,i,gs)
	if _G[EMI.aims[i.st]]["control"] then
		_G[EMI.aims[i.st]]["control"](a,i)
	end
end

return
{
	make = make,
	control = control,
}