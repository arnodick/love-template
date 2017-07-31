local function make(a,m,easing,s,d,c,p)
	m.starttime=Game.timer
	m.easing=easing
	m.startvalue=s
	m.duration=d
	m.change=c
	m.p=p
end

local function control(a,m)
	local timeelapsed=Game.timer-m.starttime
	a.zoom=m.easing(timeelapsed,m.startvalue,(timeelapsed/m.duration)*m.change,m.duration,m.p)
	if timeelapsed>=m.duration then
		a.transition=nil
	end
end

return
{
	make = make,
	control = control,
}