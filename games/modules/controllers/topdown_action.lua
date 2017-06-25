local function control(a,c)
	local i=a.input.action
	
	c.use=i.use
	c.action=i.action
end

return
{
	control = control,
}