local function make(a,i)
	i.use=false
	i.action=false
	i.lastuse=false
	i.lastaction=false
	if _G[EMI.actions[i.st]]["make"] then
		_G[EMI.actions[i.st]]["make"](a,i)
	end
end

local function control(a,i,gs)
	if _G[EMI.actions[i.st]]["control"] then
		_G[EMI.actions[i.st]]["control"](a,i)
	end
	i.lastuse=i.use
	i.lastaction=i.action
end

return
{
	make = make,
	control = control,
}