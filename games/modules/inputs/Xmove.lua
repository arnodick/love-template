local function make(a,i)
	i.horizontal=0
	i.vertical=0
	i.last={}
	i.last.vertical=0
	i.last.horizontal=0
	if _G[EMI.moves[i.st]]["make"] then
		_G[EMI.moves[i.st]]["make"](a,i)
	end
end

local function control(a,i,gs)
	if _G[EMI.moves[i.st]]["control"] then
		_G[EMI.moves[i.st]]["control"](a,i)
	end
	i.last.vertical=i.vertical
	i.last.horizontal=i.horizontal
end

return
{
	make = make,
	control = control,
}