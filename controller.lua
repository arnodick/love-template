local function make(a,t,st)
	if not a.controller then
		a.controller={}
	end

	local c={}
	c.t=t
	c.st=st

	if _G[ECT[t]]["make"] then
		_G[ECT[t]]["make"](a,c)
	end
	--table.insert(a.controller,c)
	a.controller[ECT[t]]=c
end

local function update(a,gs)
	local c=a.controller
	if c then
		for k,v in pairs(c) do
			if _G[ECT[v.t]]["control"] then
				_G[ECT[v.t]]["control"](a,v,gs)
			end
		end
	end
end

return
{
	make = make,
	update = update,
}