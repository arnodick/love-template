local function control(a,c)
	local i=a.input.aim

	c.aimhorizontal=i.horizontal
	c.aimvertical=i.vertical
end

return
{
	control = control,
}