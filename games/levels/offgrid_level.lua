local function make(g,lindex)
	lindex=math.clamp(lindex,1,#g.levels,true)
	g.timer=0

	local gamename=g.name
	local lload=g.levels[lindex]
	g.level=lindex

	local l={}
	l.t=Enums.games.levels[gamename][lload.values.t]

	if lload.values.animspeed then
		l.animspeed=lload.values.animspeed
	end

	if not lload.menu_text then
		local text=""
		if lload.values.text then
			text=lload.values.text
			
		end
		module.make(g,EM.menu,EMM.text,320,800,640,320,text,EC.white,EC.dark_gray)
	else
		local menu_functions={}
		local menu_levels={}
		for i=1,#lload.menu_levels do
			table.insert(menu_functions,level.make)
			table.insert(menu_levels,{g,lload.menu_levels[i]})
		end
		module.make(g,EM.menu,EMM.interactive,320,800,640,320,lload.menu_text,EC.white,EC.dark_gray,"left",menu_functions,menu_levels)
	end

	print(lindex)
	debugger.printtable(l)
	--print("text="..text)

	return l
end

local function control(g,l)
	if g.menu then
		menu.control(g.menu)
	end
end

local function gamepadpressed(g,l,button)
	if g.menu then
		menu.gamepadpressed(g.menu,button)
	end
end

return
{
	make = make,
	control = control,
	gamepadpressed = gamepadpressed,
}