local function make(g,lindex)
	local gamename=g.name

	local lload=g.levels[lindex]
	local l={}
	l.t=Enums.games.levels[gamename][lload.values.t]
	if lload.values.animspeed then
		l.animspeed=lload.values.animspeed
	end
	return l
end

local function control(g,l)
	
end

return
{
	make = make,
	control = control,
}