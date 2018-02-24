local function init(t)
	local c={}
--[[
	if EA[Enums.games[t] ] then
		for i=1,#EA[Enums.games[t] ] do
			c[EA[Enums.games[t] ][i] ]=0
		end
		for j,k in pairs(EA[Enums.games[t] ]) do
			if type(k)=="table" and j~="modules" then
				for i,v in pairs(k) do
					if type(i)=="string" then
						c[i]=0
					end
				end
			end
		end
	end
	c.enemy=0
--]]
	for i=1,#EA do
		c[EA[i]]=0
	end
	c.enemy=0
	return c

--[[
	--TABLE COUNTER
	local c={}
	for i=1,#Enums.actors do
		c[ EA[Enums.games[t] ][i] ]={}
	end
	c.enemy={}
	return c
--]]
end

local function update(g,c,a,amount)
	--local typecounter=c[EA[g.name][a.t]]
	--c[EA[g.name][a.t]]=c[EA[g.name][a.t]]+amount
	c[EA[a.t]]=c[EA[a.t]]+amount
	--local typename=EA[g.name][a.t].."s"
	--c[EA[g.name][typename][a.st]]=c[EA[g.name][typename][a.st]]+amount
	if flags.get(a.flags,EF.enemy) then
		c.enemy=c.enemy+amount
	end
--[[
	--TABLE COUNTER INCREMENT
	table.insert(c[ EA[g.name ][a.t] ],a)
	if flags.get(a.flags,EF.enemy) then
		table.insert(c.enemy,a)
	end


	--TABLE COUNTER DECREMENT
	for j,k in pairs(c[ EA[g.name ][v.t] ]) do
		if k==v then
			table.remove(c[ EA[g.name ][v.t] ],j)
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