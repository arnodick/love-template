local function make(m,sound,time,colour)
	m.hit=0
	m.sfx=sound
	m.time=time
	m.colour=colour
end

return
{
	make = make,
}