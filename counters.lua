local function init()
	local c={}
	for i=1,#Enums.actors do
		c[EA[i]]={}
	end
	c.enemy={}
	return c
end

local function update(c,a)
	table.insert(c[EA[a.t]],a)
	if flags.get(a.flags,Enums.flags.enemy) then
		table.insert(c.enemy,a)
	end
end

--[[
local function update(c,a)

	if flags.get(a.flags,Enums.flags.enemy) then
		c.enemies=c.enemies+1
	end

end
--]]

return
{
	init = init,
	update = update,
}