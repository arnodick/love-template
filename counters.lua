local function make()
	local c={}
	c.enemies=0
	return c
end

local function update(c,a)
	if flags.get(a.flags,Enums.flags.enemy) then
		c.enemies=c.enemies+1
	end
end

return
{
	make = make,
	update = update,
}