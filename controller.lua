local function make(a,ct)
	a.ct=ct
	a.controller={{0,true},{0,true},{0,true},{0,false},{0,false},{0,true},{false,true},{false,true}}
end

local function update(c,ct)
	for i=1,#c do
		if c[i][2] then
			if type(c[i][1])=="number" then
				c[i][1]=0
			elseif type(c[i][1])=="boolean" then
				c[i][1]=false
			end
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