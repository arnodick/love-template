local function make(g,l,index)
	index=math.clamp(index,1,#g.levels,true)
	g.timer=0
	g.level=index
	local gamename=g.name
	local lload=g.levels[index]
	
	l.t=Enums.games.levels[gamename][lload.values.t]

	if lload.values.animspeed then
		l.animspeed=lload.values.animspeed
	end

	if l.t==Enums.games.levels.offgrid.city then
		local menu_functions={}
		local menu_arguments={}
		table.insert(menu_functions,offgrid.move)
		table.insert(menu_functions,offgrid.move)
		table.insert(menu_functions,offgrid.move)
		table.insert(menu_functions,offgrid.move)
		
		table.insert(menu_arguments,{g,g.player.x,g.player.y-1})
		table.insert(menu_arguments,{g,g.player.x+1,g.player.y})
		table.insert(menu_arguments,{g,g.player.x,g.player.y+1})
		table.insert(menu_arguments,{g,g.player.x-1,g.player.y})
		module.make(g,EM.menu,EMM.interactive_fiction,320,800,640,320,{"North","East","South","West"},EC.white,EC.dark_gray,"left",menu_functions,menu_arguments)
	elseif not lload.menu_text then
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
		module.make(g,EM.menu,EMM.interactive_fiction,320,800,640,320,lload.menu_text,EC.white,EC.dark_gray,"left",menu_functions,menu_levels)
	end

	print(index)
	debugger.printtable(l)
	--print("text="..text)
end

local function control(g,l)
	if g.menu then
		menu.control(g.menu)
	end
end

local function keypressed(g,l,key)
	if g.menu then
		menu.keypressed(g.menu,key)
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
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
}