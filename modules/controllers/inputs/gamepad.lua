local function move(a)
	local j=Joysticks[a.controller.move.id]
	--local deadzone=0.25
	--TODO just use clamp instead of this?
	--gamepad.deadzone(i,deadzone)
	return j:getGamepadAxis("leftx"),j:getGamepadAxis("lefty")
end

local function aim(a)
	local j=Joysticks[a.controller.move.id]
	--local deadzone=0.25
	--gamepad.deadzone(i,deadzone)
	return j:getGamepadAxis("rightx"),j:getGamepadAxis("righty")
end

local function action(a)
	local j=Joysticks[a.controller.move.id]
	local use,action=false,false

	if j:isDown(3) or j:getGamepadAxis("triggerright")>0 then
		use=true
	end
	if j:isDown(1) or j:getGamepadAxis("triggerleft")>0 then
		action=true
	end

	return use,action
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