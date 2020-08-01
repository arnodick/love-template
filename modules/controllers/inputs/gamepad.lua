local gamepad={}

gamepad.move = function(a)
	local j=Joysticks[a.controller.move.id]
	-- print(j:getGamepadAxis("leftx").." "..j:getGamepadAxis("lefty"))

	--TODO return normalized values here if digital or vector if analog, make local functions output.digital and output.analog and run like output[c.outputtype]
	--give controllers a diagonal option as well, whether only one dir at a time or two
	return j:getGamepadAxis("leftx"),j:getGamepadAxis("lefty")
end

gamepad.aim = function(a)
	local j=Joysticks[a.controller.move.id]
	return j:getGamepadAxis("rightx"),j:getGamepadAxis("righty")
end

gamepad.action = function(a)
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

return gamepad