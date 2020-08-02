local gamepad={}
local output={}

--TODO input move controller here
gamepad.move = function(a,c)
	local j=Joysticks[a.controller.move.id]
	-- print(j:getGamepadAxis("leftx").." "..j:getGamepadAxis("lefty"))

	--TODO return normalized values here if digital or vector if analog, make local functions output.digital and output.analog and run like output[c.outputtype]
	--give controllers a diagonal option as well, whether only one dir at a time or two

	return output[c.inputtype](a,j)
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

output.analog = function(a,j)
	return j:getGamepadAxis("leftx"),j:getGamepadAxis("lefty")
end

output.digital = function(a,j)
	local x,y=0,0
	if j:isGamepadDown("dpleft") then
		x=-1
	elseif j:isGamepadDown("dpright") then
		x=1
	elseif j:isGamepadDown("dpup") then
		y=-1
	elseif j:isGamepadDown("dpdown") then
		y=1
	else
		x,y=j:getGamepadAxis("leftx"),j:getGamepadAxis("lefty")
		if math.abs(x)>=math.abs(y) then
			y=0
		else
			x=0
		end
	end
	return x,y
end

return gamepad