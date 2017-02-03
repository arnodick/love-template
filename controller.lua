local function make(a,ct)
	a.ct=ct
	a.controller={0,0,false,false}
end

local function update(c,ct)
	for i=1,#c do
		if type(c[i])=="number" then
			c[i]=0
		elseif type(c[i])=="boolean" then
			c[i]=false
		end
	end

	if _G[Enums.controlnames[ct]]["control"] then
		_G[Enums.controlnames[ct]]["control"](c)
	end
end

--TODO make player and follow functions here? _G[controller][Enums.controlnames[ct]]

return--TODO add all local function to a table and return the unpacked table?
{
	make = make,
	update = update,
}