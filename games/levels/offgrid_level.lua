local function make(g,l,index)
	--index=math.clamp(index,1,#g.levels,true)
	g.timer=0
	g.level=index
	local gamename=g.name
	local lload=g.levels[index]
	
	l.t=Enums.games.levels[gamename][lload.values.t]
	l.title=lload.values.title

	if lload.values.animspeed then
		l.animspeed=lload.values.animspeed
	end

	if l.t==Enums.games.levels.offgrid.city then
		local m={}
		m.text={}
		m.arguments={}
		m.functions={}
		
		offgrid_level.makemenuoption(g,m,g.player.x,g.player.y-1,"North",1)
		offgrid_level.makemenuoption(g,m,g.player.x+1,g.player.y,"East",2)
		offgrid_level.makemenuoption(g,m,g.player.x,g.player.y+1,"South",3)
		offgrid_level.makemenuoption(g,m,g.player.x-1,g.player.y,"West",4)

		module.make(g,EM.menu,EMM.interactive_fiction,320,800,640,320,m.text,EC.white,EC.dark_gray,"left",m.functions,m.arguments)
		if lload.values.description then
			g.menu.description=lload.values.description
			module.make(g.menu,EM.transition,easing.linear,"text_trans",0,string.len(g.menu.description),360)
		else
			g.menu.description=nil
		end
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

	module.make(l,EM.transition,easing.linear,"transition_timer",0,1,240,nil,nil,EM.transitions.screen_transition_blocksreverse)
	--print(index)
	--debugger.printtable(l)
	--print("text="..text)
end

local function control(g,l)
	if g.menu then
		menu.control(g.menu)
	end
end

local function keypressed(g,l,key)
	if key=='z' then
		sfx.play(13)
	end
--[[
	local glc = g.levels.current
	if not glc or not glc.transition then
		if g.menu then
			menu.keypressed(g.menu,key)
		end
	end
--]]
end

local function keyreleased(g,l,key)
	local glc = g.levels.current
	if not glc or not glc.transition then
		if g.menu then
			menu.keypressed(g.menu,key)
		end
	end
end

local function gamepadpressed(g,l,button)
	if g.menu then
		menu.gamepadpressed(g.menu,button)
	end
end

local function draw(g,l)

end

local function makemenuoption(g,m,x,y,dir,index)
--checks if a point on the map has a level in it
--if so, puts that in the menu as an option
	if g.map[y] then
		if g.map[y][x] then	
			local value=g.map[y][x]
			if g.levels[value] then
				local destination=g.levels[value].values.title
				table.insert(m.text,"Go "..dir.." to "..destination)

				table.insert(m.functions,offgrid.move)
				table.insert(m.arguments,{g,x,y})
			end
		end
	end
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	keyreleased = keyreleased,
	gamepadpressed = gamepadpressed,
	draw = draw,
	makemenuoption = makemenuoption,
}