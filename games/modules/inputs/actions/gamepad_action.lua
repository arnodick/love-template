local function control(a,c)
	local j=Joysticks[1]

	if j:isDown(3) or j:getGamepadAxis("triggerright")>0 then
		c.use=true
	else
		c.use=false
	end
	if j:isDown(1) or j:getGamepadAxis("triggerleft")>0 then
		c.action=true
	else
		c.action=false
	end
end

return
{
	control = control,
}