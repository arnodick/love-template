local function control(a,c)
	local i=a.input.move
	c.movehorizontal=i.horizontal
	c.movevertical=i.vertical
end

return
{
	control = control,
}