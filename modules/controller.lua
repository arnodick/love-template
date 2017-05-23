local function make(a,cont,t,st,target,y)
	cont[EMC[t]]={}
	local c=cont[EMC[t]]
	c.t=t
	c.st=st

	if target then
		if not c.target then
			c.target={}
		end
		if type(target)=='table' then
			c.target=target
		else
			c.target.x=target
			c.target.y=y
		end
	end

	if _G[EMC[t]]["make"] then
		_G[EMC[t]]["make"](a,c)
	end
end

local function update(a,gs)
	local c=a.controller
	if c then
		for k,v in pairs(c) do
			if _G[EMC[v.t]]["control"] then
				_G[EMC[v.t]]["control"](a,v,gs)
			end
		end
	end
end

local function gamepadpressed(a,button)
	local c=a.controller
	if c then
		for k,v in pairs(c) do
			if _G[EMC[v.t]]["gamepadpressed"] then
				_G[EMC[v.t]]["gamepadpressed"](a,v,button)
			end
		end
	end

end

return
{
	make = make,
	update = update,
	gamepadpressed = gamepadpressed,
}