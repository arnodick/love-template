local function control(a,c)	
	c.horizontal,c.vertical=_G[EI[c.i]][EMC[c.t]]()
end

return
{
	control = control,
}