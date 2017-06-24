local function control(a,c)
	c.movehorizontal=love.math.random(-1,1)
	c.movevertical=love.math.random(-1,1)
end

return
{
	control = control,
}