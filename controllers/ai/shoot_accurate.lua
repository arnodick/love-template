local function control(a)
	local e=Enums.commands
	local c=a.controller

	--TODO make this a general target, rather than specifically Player
	local dir=vector.direction(vector.components(a.x,a.y,a.target.x,a.target.y))
	c.aimhorizontal=math.cos(dir)
	c.aimvertical=math.sin(dir)

	if love.math.random(20)==1 then--or a.st==Enums.actors.characters.mushroom then
		c.shoot=true
	else
		c.shoot=false
	end
end

return
{
	control = control,
}