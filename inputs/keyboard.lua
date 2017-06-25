local function leftstick()
	local j=Joysticks[1]--TODO make joystick id or something assigned to actor
	--local deadzone=0.25

	--TODO just use clamp instead of this?
	--gamepad.deadzone(i,deadzone)

	return 	j:getGamepadAxis("leftx"), j:getGamepadAxis("lefty")
end

local function rightstick()
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

local function deadzone()
	local axes={"movehorizontal","movevertical"}
	for i=1,#axes do
		if c[axes[i]]>0 and c[axes[i]]<dz then
			c[axes[i]]=0
		end

		if c[axes[i]]<0 and c[axes[i]]>-dz then
			c[axes[i]]=0
		end
	end
end

return
{
	leftstick = leftsick,
	rightstick = rightstick,
	deadzone = deadzone,
}