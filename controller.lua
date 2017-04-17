local function make(a,t,st,target,y)
	if not a.controller then
		a.controller={}
	end

	if target then
		if not a.target then
			a.target={}
		end
		if type(target)=='table' then
			a.target[ECT[t]]=target
		else
			a.target.x=target
			a.target.y=y
		end
	end

	local c={}
	c.t=t
	c.st=st

	if _G[ECT[t]]["make"] then
		_G[ECT[t]]["make"](a,c)
	end
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