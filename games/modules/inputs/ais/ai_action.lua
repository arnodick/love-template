local function move()
	return 	j:getGamepadAxis("leftx"), j:getGamepadAxis("lefty")
end

local function aim()
	return 	j:getGamepadAxis("rightx"), j:getGamepadAxis("righty")
end

local function action()
	local use=false
	local action=false

	if j:isDown(3) or j:getGamepadAxis("triggerright")>0 then
		use=true
	end

	if j:isDown(1) or j:getGamepadAxis("triggerleft")>0 then
		action=true
	end

	return 	use, action
end


return
{
	move = move,
	aim = aim,
	action = action,
}