local function make(x,y)
	local c={}
	c.x=x
	c.y=y
	c.zoom=1
	--c.shake=0
	c.hit=0
	return c
	--TODO this should insert itself into Game.cameras, can have multiple cameras and jump around from one to another
end

local function control(c,t,gs)
	--[[
	if c.shake>0 then
		c.shake = c.shake - gs
	end
	--]]
end

return
{
	make = make,
	control = control,
}