local function make(a,m,easing,variablename,s,c,d,p)
	m.starttime=Game.timer
	m.easing=easing
	m.variablename=variablename
	m.startvalue=s
	m.change=c
	m.duration=d
	m.p=p
end

local function control(a,m)
	local timeelapsed=Game.timer-m.starttime
	a[m.variablename]=m.easing(timeelapsed,m.startvalue,m.change,m.duration,m.p)
	if timeelapsed>=m.duration then
		a.transition=nil
	end
end

return
{
	make = make,
	control = control,
}