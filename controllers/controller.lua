local function make()
	return {0,0,0,0,0,0,false,false}
end

local function update(a,gs)
	if a.ct then
		if _G[Enums.controllernames[a.ct]]["control"] then
			_G[Enums.controllernames[a.ct]]["control"](a,gs)
		end
	end
end

return--TODO add all local function to a table and return the unpacked table?
{
	make = make,
	update = update,
}