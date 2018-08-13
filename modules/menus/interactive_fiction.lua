local function make(m,menu_functions,menu_function_args)
	m.menu_functions=menu_functions
	m.menu_function_args=menu_function_args
	m.text.index=1
	module.make(m,EM.controller,EMC.move,EMCI.keyboard)
	--module.make(m,EM.controller,EMC.select,EMC.selects.gamepad_menu_select)
end

local function control(g,m,gs)
	controller.update(m,gs)
	local c=m.controller.move

	if c.vertical<0 then
		if c.last.vertical>=0 then
			local oldindex=m.text.index
			if oldindex<5 then
				local x,y=g.player.x,g.player.y-1
				interactive_fiction.getindexfrompoint(m,x,y)
			elseif oldindex>5 then
				m.text.index=m.text.index-1
			end
			--m.text.index=math.clamp(m.text.index-1,1,#m.text,true)
		end
	elseif c.vertical>0 then
		if c.last.vertical<=0 then
			local oldindex=m.text.index
			if oldindex<5 then
				local x,y=g.player.x,g.player.y+1
				interactive_fiction.getindexfrompoint(m,x,y)
			elseif oldindex>=5 and oldindex<4+#m.options then
				m.text.index=m.text.index+1
			end
		end
	end
	if c.horizontal<0 then
		if c.last.horizontal>=0 then
			local oldindex=m.text.index
			if oldindex<5 then
				local x,y=g.player.x-1,g.player.y
				interactive_fiction.getindexfrompoint(m,x,y)
			else
				m.text.index=1
			end
		end
	elseif c.horizontal>0 then
		if c.last.horizontal<=0 then
			local oldindex=m.text.index
			if oldindex<5 then
				local x,y=g.player.x+1,g.player.y
				interactive_fiction.getindexfrompoint(m,x,y)
			end
			if oldindex==m.text.index then
				if m.options then
					m.text.index=5
				end
			end
		end
	end

	if m.transition then
		transition.control(m,m.transition)
		if m.text_trans-math.floor(m.text_trans)<0.1 then
			sfx.play(16)
		end
	--[[
		if m.keysound then
			sfx.play(16)
			m.keysound=false
		elseif math.floor(m.text_trans)%4==0 then
			m.keysound=true
		end
--]]
	end
end

local function keypressed(m,key)
	if not m.transition then
		if key=='z' then
			sfx.play(13)
		end
	end
end

local function keyreleased(m,key)
	if not m.transition then
		if key=='z' then
			sfx.play(14)
			local i=m.text.index
			print("INDEX: "..i)
			if m.menu_functions[i] then
				local g=Game
				if g.level.transition_out then
					--module.make(g.level,EM.transition,easing.linear,"transition_timer",0,1,240,m.menu_functions[i],m.menu_function_args[i],EM.transitions.screen_transition_blocks)
					module.make(g.level,EM.transition,easing.linear,"transition_timer",0,1,240,m.menu_functions[i],m.menu_function_args[i],EM.transitions[g.level.transition_out])
				else
					m.menu_functions[i](unpack(m.menu_function_args[i]))
				end
				--module.make(g.level,EM.transition,easing.linear,"transition_timer",0,1,40,m.menu_functions[i],m.menu_function_args[i],EM.transitions.screen_transition_blocks)
				--module.make(g.level,EM.transition,easing.linear,"transition_timer",0,1,40,m.menu_functions[i],m.menu_function_args[i],EM.transitions.screen_transition_crush)
				--module.make(g.level,EM.transition,easing.linear,"transition_timer",1,6400,64,m.menu_functions[i],m.menu_function_args[i],EM.transitions.screen_transition_text)
				--module.make(g.level,EM.transition,easing.linear,"transition_timer",1,6400,64,m.menu_functions[i],m.menu_function_args[i],EM.transitions.screen_transition_text_dissolve)
			end
		end
	else
		if key=='z' then
			m.transition.duration=120
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
	if not m.back then
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

			LG.line(arrowx,arrowy+arrowlength,arrowx,arrowy-arrowlength)
			LG.line(arrowx-arrowlength,arrowy,arrowx+arrowlength,arrowy)

			local linealpha=255
			if m.text.index then
				if m.text.index~=i then
					linealpha=50
				end
			end
			LG.printformat(m.text[i],points[1],points[2],m.w/8,"center",m.c1,m.c2,linealpha)
		end
	else
		LG.printformat(m.text[1],m.x-m.w/8-220,m.y,m.w/8,"center",m.c1,m.c2,255)
	end
	if m.description then
		local colourtext={}
		for i=1,string.len(m.description) do
			--table.insert(colourtext,{love.math.random(255),love.math.random(255),love.math.random(255)})
			if i<=m.text_trans then
				if m.options then
					local colour={255,255,255}
					for index,v in ipairs(m.options) do
						if not v.unlock or (v.unlock and g.player.items[v.unlock]) then
							if i>=v.first and i<=v.last then
								if m.text.index~=index+4 then
									colour={0,0,100}
								else
									colour={0,0,255}
								end
							end
						end
					end
					table.insert(colourtext,colour)
				else
					table.insert(colourtext,{255,255,255})
				end
			else
				table.insert(colourtext,{0,0,0})
			end
			table.insert(colourtext,string.sub(m.description,i,i))
		end
		--LG.printformat(colourtext,300,700,g.width/2,"left",EC.white,EC.blue,255)
		LG.printf(colourtext,300,700,g.width/2,"left")	
	end
end

local function getindexfrompoint(m,x,y)
--checks all available menu options to see if one of them points to the same spot on the map as the input (presumably player's key input)
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
	keyreleased = keyreleased,
	draw = draw,
	getindexfrompoint = getindexfrompoint,
}