local function control(a,c)
	local i=a.input.action
	
	c.use=i.use
	c.action=i.action

	if a.inventory then
		if #a.inventory>0 then
			item.use(a.inventory[1],gs,a,c.aimhorizontal,c.aimvertical,c.use)
		end
	end
end

return
{
	control = control,
}