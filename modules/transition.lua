local function make(a,m,s,d,c)
	m.starttime=Game.timer
	m.startvalue=s
	m.duration=d
	m.change=c
end

local function control(a,m)
	local timeelapsed=Game.timer-m.starttime
	a.zoom=math.ease(timeelapsed,m.startvalue,(timeelapsed/m.duration)*m.change,m.duration)
	if timeelapsed>=m.duration then
		a.transition=nil
	end
end

return
{
	make = make,
	control = control,
}