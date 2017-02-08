local function control(a)
	local e=Enums.buttons
	local c=a.controller

	if love.keyboard.isDown('left') then
		c[e.leftstickhorizontal]=-1
	elseif love.keyboard.isDown('right') then
		c[e.leftstickhorizontal]=1
	end

	if love.keyboard.isDown('up') then
		c[e.leftstickvertical]=-1
	elseif love.keyboard.isDown('down') then
		c[e.leftstickvertical]=1
	end

	if love.keyboard.isDown('z') then
		c[e.button1]=true
	else
		c[e.button1]=false
	end

	if love.keyboard.isDown('x') then
		c[e.lefttrigger]=1
	else
		c[e.lefttrigger]=-1
	end
end

return
{
	control = control,
}