local function control(a,c)
	if love.math.random( math.max(40-(a.rage*10),10) )==1 then
		c.use=true
	else
		c.use=false
	end
end

return
{
	control = control,
}