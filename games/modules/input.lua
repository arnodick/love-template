local function make(a,input,t,st)
	input[EMI[t]]={}
	local i=input[EMI[t]]
	i.t=t
	i.st=st

	if _G[EMI[t]]["make"] then
		_G[EMI[t]]["make"](a,i)
	end
end

local function update(a,gs)
	local i=a.input
	if i then
		for k,v in pairs(i) do
			if _G[EMI[v.t]]["control"] then
				_G[EMI[v.t]]["control"](a,v,gs)
			end
		end
	end
end

--[[
local function gamepadpressed(a,button)
	local c=a.controller
	if c then
		for k,v in pairs(c) do
			if _G[EMC[v.t] ]["gamepadpressed"] then
				_G[EMC[v.t] ]["gamepadpressed"](a,v,button)
			end
		end
	end
end

local function deadzone(c,dz)
	local axes={"movehorizontal","movevertical"}
	for i=1,#axes do
		if c[axes[i] ]>0 and c[axes[i] ]<dz then
			c[axes[i] ]=0
		end

		if c[axes[i] ]<0 and c[axes[i] ]>-dz then
			c[axes[i] ]=0
		end
	end
end
--]]

return
{
	make = make,
	update = update,
	--gamepadpressed = gamepadpressed,
	--deadzone = deadzone
}