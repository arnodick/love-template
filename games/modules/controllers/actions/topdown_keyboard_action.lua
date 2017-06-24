local function control(a,c)
	if love.keyboard.isDown('z') then
		c.use=true
	else
		c.use=false
	end

	if love.keyboard.isDown('x') then
		c.action=true
	else
		c.action=false
	end
end

return
{
	control = control,
}