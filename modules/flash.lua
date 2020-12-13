local function make(g,a,m,variablename,flashvalue,startvalue,duration)
	m.starttime=g.timer
	m.variablename=variablename
	m.flashvalue=flashvalue
	m.startvalue=startvalue
	m.duration=duration
end

local function control(g,a,m)
	local timeelapsed=g.timer-m.starttime
	a[m.variablename]=m.flashvalue
	if timeelapsed>=m.duration then
		a[m.variablename]=m.startvalue
		a.flash=nil
	end
end

return
{
	make = make,
	control = control,
}