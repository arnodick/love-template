local function control(a)
	local e=Enums.commands
	local c=a.controller

	--TODO make this a general target, rather than specifically Player
	local dir=vector.direction(vector.components(a.x,a.y,a.target.x,a.target.y))
	c.aimhorizontal=math.cos(dir)
	c.aimvertical=math.sin(dir)

	if love.math.random( math.max(40-(a.rage*10),10) )==1 then
		c.shoot=true
	else
		c.shoot=false
	end
end

return
{
	control = control,
}