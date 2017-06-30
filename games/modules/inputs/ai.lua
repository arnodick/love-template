local function move(a,c)

	return 	j:getGamepadAxis("leftx"), j:getGamepadAxis("lefty")
end

local function aim(a,c)
	local aimhor,aimver=0,0
	local i=c.input
	if _G[EMI.ais[i.st]] then
		aimhor,aimver=_G[EMI.ais[i.st]]["aim"](a,c)
	end
	return 	aimhor,aimver
end

local function action(a,c)
	local use=false
	local action=false


	return 	use, action
end


return
{
	move = move,
	aim = aim,
	action = action,
}