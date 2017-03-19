local function init()
	local c={}
	for i=1,#Enums.actors do
		c[EA[i]]=0
	end
	c.enemy=0
	return c

--[[
	--TABLE COUNTER
	local c={}
	for i=1,#Enums.actors do
		c[ EA[i] ]={}
	end
	c.enemy={}
	return c
--]]
end

local function update(c,a,amount)
	--local typecounter=c[EA[a.t]]
	c[EA[a.t]]=c[EA[a.t]]+amount
	if flags.get(a.flags,Enums.flags.enemy) then
		c.enemy=c.enemy+amount
	end
--[[
	--TABLE COUNTER INCREMENT
	table.insert(c[ EA[a.t] ],a)
	if flags.get(a.flags,Enums.flags.enemy) then
		table.insert(c.enemy,a)
	end


	--TABLE COUNTER DECREMENT
	for j,k in pairs(Counters[ EA[v.t] ]) do
		if k==v then
			table.remove(Counters[ EA[v.t] ],j)
		end
	end

	if flags.get(v.flags,Enums.flags.enemy) then
		for j,k in pairs(Counters.enemy) do
			if k==v then
				table.remove(Counters.enemy,j)
			end
		end
	end
--]]

end

return
{
	init = init,
	update = update,
}