local function control(c)
	if love.keyboard.isDown('left') then
		c[1]=-1
	elseif love.keyboard.isDown('right') then
		c[1]=1
	end

	if love.keyboard.isDown('up') then
		c[2]=-1
	elseif love.keyboard.isDown('down') then
		c[2]=1
	end

	if love.keyboard.isDown('z') then
		c[3]=true
	end

	if love.keyboard.isDown('x') then
		c[4]=true
	end
end

return
{
	control = control,
}