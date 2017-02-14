local function make(a)
	local e=Enums.commands
	local c=a.controller
	c[e.movehorizontal]=math.choose(-1,1)
end

local function control(a)
	local e=Enums.commands
	local c=a.controller

	if a.x<=0 then
		c[e.movehorizontal]=1
	elseif a.x>=320 then
		c[e.movehorizontal]=-1
	end
end

return
{
	make = make,
	control = control,
}