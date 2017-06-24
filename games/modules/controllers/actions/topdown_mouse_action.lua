local function control(a,c)
	if love.mouse.isDown(1) then
		c.use=true
	else
		c.use=false
	end
	if love.mouse.isDown(2) then
		c.action=true
	else
		c.action=false
	end
end

return
{
	control = control,
}