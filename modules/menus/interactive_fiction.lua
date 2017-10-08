local function make(m,menu_functions,menu_function_args)
	m.menu_functions=menu_functions
	m.menu_function_args=menu_function_args
	m.text.index=1
	module.make(m,EM.controller,EMC.move,EMCI.keyboard)
	--module.make(m,EM.controller,EMC.select,EMC.selects.gamepad_menu_select)
end

local function control(m)
	local g=Game
	controller.update(m)
	local c=m.controller.move

	if c.vertical<0 then
		if c.last.vertical>=0 then
			local x,y=g.player.x,g.player.y-1
			interactive_fiction.getindexfrompoint(m,x,y)
			--m.text.index=math.clamp(m.text.index-1,1,#m.text,true)
		end
	elseif c.vertical>0 then
		if c.last.vertical<=0 then
			local x,y=g.player.x,g.player.y+1
			interactive_fiction.getindexfrompoint(m,x,y)
		end
	end
	if c.horizontal<0 then
		if c.last.horizontal>=0 then
			local x,y=g.player.x-1,g.player.y
			interactive_fiction.getindexfrompoint(m,x,y)
		end
	elseif c.horizontal>0 then
		if c.last.horizontal<=0 then
			local x,y=g.player.x+1,g.player.y
			interactive_fiction.getindexfrompoint(m,x,y)
		end
	end
end

local function keypressed(m,key)
	if key=='z' then
		local i=m.text.index
		if m.menu_functions[i] then
			local g=Game
			module.make(g.levels.current,EM.transition,easing.linear,"transition_timer",1,6400,64,m.menu_functions[i],m.menu_function_args[i],EM.transitions.screen_transition_text_dissolve)
			--module.make(g.levels.current,EM.transition,easing.linear,"transition_timer",1,6400,64,m.menu_functions[i],m.menu_function_args[i],EM.transitions.screen_transition_text)

			--module.make(g.levels.current,EM.transition,easing.linear,"transition_timer",0,1,40,m.menu_functions[i],m.menu_function_args[i],EM.transitions.screen_transition_text)
			--module.make(g.levels.current,EM.transition,easing.linear,"transition_timer",0,1,40,m.menu_functions[i],m.menu_function_args[i],EM.transitions.screen_transition_blocks)
		end
	end
end

local function gamepadpressed(m,button)
	if button=='start' or button=='a' then
		local i=m.text.index
		if m.menu_functions[i] then
			m.menu_functions[i](unpack(m.menu_function_args[i]))
		end
	end
end

local function draw(m)
	local g=Game
	for i=1,#m.text do
		local points={}
		local xoff=220
		local arrowx,arrowy=m.x-180,m.y
		local arrowlength=30

		if m.menu_function_args[i][2]<g.player.x then
			points={m.x-m.w/8-xoff,m.y}
		elseif m.menu_function_args[i][2]>g.player.x then
			points={m.x+m.w/8-xoff,m.y}
		elseif m.menu_function_args[i][3]<g.player.y then
			points={m.x-xoff,m.y-m.h/4}
		elseif m.menu_function_args[i][3]>g.player.y then
			points={m.x-xoff,m.y+m.h/8}
		end

		--LG.line(m.x-xoff+40,m.y+arrowlength,m.x-xoff+40,m.y-arrowlength)
		LG.line(arrowx,arrowy+arrowlength,arrowx,arrowy-arrowlength)
		--LG.line(m.x-xoff+40-arrowlength,m.y,m.x-xoff+40+arrowlength,m.y)
		LG.line(arrowx-arrowlength,arrowy,arrowx+arrowlength,arrowy)

		local linealpha=255
		if m.text.index then
			if m.text.index~=i then
				linealpha=50
			end
		end
		LG.printformat(m.text[i],points[1],points[2],m.w/8,"center",m.c1,m.c2,linealpha)
		--LG.print("x",m.x-xoff,m.y)
	end
end

local function getindexfrompoint(m,x,y)
--checks all available menu options to see if one of the points to the same spot on the map as the input (presumably player's key input)
--if so, sets the menu's index value to that menu option's index (ie the direction the player pushed is selected if it is an option)
	for i=1,#m.text do
		if m.menu_function_args[i][2]==x and m.menu_function_args[i][3]==y then
			m.text.index=i
		end
	end
end

return
{
	make = make,
	control = control,
	gamepadpressed = gamepadpressed,
	keypressed = keypressed,
	draw = draw,
	getindexfrompoint = getindexfrompoint,
}