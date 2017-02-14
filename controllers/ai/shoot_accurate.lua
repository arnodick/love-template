local function control(a)
	local e=Enums.commands
	local c=a.controller

	--TODO make this a general target, rather than specifically Player
	local dir=vector.direction(vector.components(a.x,a.y,Player.x,Player.y))
	c[e.aimhorizontal]=math.cos(dir)
	c[e.aimvertical]=math.sin(dir)

	if love.math.random(20)==1 or a.st==Enums.characters.mushroom then
		c[e.shoot]=true
	else
		c[e.shoot]=false
	end
end

return
{
	control = control,
}