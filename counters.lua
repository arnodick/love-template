local function init()
	local c={}
	for i=1,#EA do
		c[EA[i]]=0
	end
	for j,k in pairs(EA) do
		if type(k)=="table" then
			for i,v in pairs(k) do
				if type(i)=="string" then
					c[i]=0
				end
			end
		end
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
	local typename=EA[a.t].."s"
	c[EA[typename][a.st]]=c[EA[typename][a.st]]+amount
	if flags.get(a.flags,EF.enemy) then
		c.enemy=c.enemy+amount
	end
--[[
	--TABLE COUNTER INCREMENT
	table.insert(c[ EA[a.t] ],a)
	if flags.get(a.flags,EF.enemy) then
		table.insert(c.enemy,a)
	end


	--TABLE COUNTER DECREMENT
	for j,k in pairs(c[ EA[v.t] ]) do
		if k==v then
			table.remove(c[ EA[v.t] ],j)
		end
	end

	if flags.get(v.flags,EF.enemy) then
		for j,k in pairs(c.enemy) do
			if k==v then
				table.remove(c.enemy,j)
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