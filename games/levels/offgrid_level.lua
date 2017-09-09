local function make(g,lindex)
	local gamename=g.name

	local lload=g.levels[lindex]
	local l={}
	l.t=Enums.games.levels[gamename][lload.values.t]
	l.animspeed=10
	if lload.values.animspeed then
		l.animspeed=lload.values.animspeed
	end

	local text=""
	if lload.values.text then
		text=lload.values.text
	end
	module.make(g,EM.menu,EMM.text,320,800,640,320,text,EC.white,EC.dark_gray)

--[[	
	if g.levels.current.text then
		text=g.levels.current.text
	end
--]]
	

	return l
end

local function control(g,l)
	
end

return
{
	make = make,
	control = control,
}