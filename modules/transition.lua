local function make(a,m,easing,variablename,startvalue,change,duration)
	m.starttime=Game.timer
	m.easing=easing
	m.variablename=variablename
	m.startvalue=startvalue
	m.change=change
	m.duration=duration
	a[m.variablename]=startvalue
end

local function control(a,m)
	local timeelapsed=Game.timer-m.starttime
	a[m.variablename]=m.easing(timeelapsed,m.startvalue,m.change,m.duration)
	if timeelapsed>=m.duration then
		a.transition=nil
	end
end

return
{
	make = make,
	control = control,
}