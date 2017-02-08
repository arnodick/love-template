local function control(a)
	local c=controller.make()
	local e=Enums.buttons

	local dir=vector.direction(vector.components(a.x,a.y,Player.x,Player.y))
	c[e.rightstickhorizontal]=math.cos(dir)
	c[e.rightstickvertical]=math.sin(dir)
	if a.x<=0 then
		a.move=1
	elseif a.x>=320 then
		a.move=-1
	end
	c[e.leftstickhorizontal]=a.move
	if love.math.random(20)==1 then
		c[e.button1]=true
	end

	return c
end

return
{
	control = control,
}