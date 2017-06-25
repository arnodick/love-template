local function move()
	local j=Joysticks[1]--TODO make joystick id or something assigned to actor
	--local deadzone=0.25

	--TODO just use clamp instead of this?
	--gamepad.deadzone(i,deadzone)

	return 	j:getGamepadAxis("leftx"), j:getGamepadAxis("lefty")
end

local function aim()
	local j=Joysticks[1]--TODO make joystick id or something assigned to actor
	--local deadzone=0.25

	--gamepad.deadzone(i,deadzone)

	return 	j:getGamepadAxis("rightx"), j:getGamepadAxis("righty")
end

local function action()
	local j=Joysticks[1]--TODO make joystick id or something assigned to actor
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

local function deadzone(v,dz)
	if v>0 and v<dz then
		v=0
	end

	if v<0 and v>-dz then
		v=0
	end
	return v
end

return
{
	move = move,
	aim = aim,
	action = action,
	deadzone = deadzone,
}