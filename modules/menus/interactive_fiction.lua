local function make(m,menu_functions,menu_function_args)
	m.menu_functions=menu_functions
	m.menu_function_args=menu_function_args
	debugger.printtable(m.menu_functions)
	if m.text then
		m.text.index=1
	end
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
				local v=m.options[m.text.index-4-1]
				if not v.unlock or (v.unlock and g.player.items[v.unlock]) then
					m.text.index=m.text.index-1
				end
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
				local v=m.options[m.text.index-4+1]
				if not v.unlock or (v.unlock and g.player.items[v.unlock]) then
					m.text.index=m.text.index+1
				end
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
					for i,v in ipairs(m.options) do
						if not v.unlock or (v.unlock and g.player.items[v.unlock]) then
							m.text.index=4+i
							print("INDEX "..4+i)
						end
					end
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
				if m.menu_functions[i]==game.make then
					m.menu_functions[i](unpack(m.menu_function_args[i]))
				else
					print("MENU INDEX: "..i)
					local g=Game
					local l={}
					if i<5 then
						if not m.back then
							l=g.levels[g.map[m.menu_function_args[i][3]][m.menu_function_args[i][2]]]
						else
							l=g.levels[m.back]
						end
					else
						l=g.levels[m.menu_function_args[i][2]]
					end
					if not l.unlock or (l.unlock and g.player.items[l.unlock]) then
						if g.level.transition_out then
							module.make(g.level,EM.transition,easing.linear,"transition_timer",0,1,240,m.menu_functions[i],m.menu_function_args[i],EM.transitions[g.level.transition_out])
						else
							m.menu_functions[i](unpack(m.menu_function_args[i]))
						end
					end
				end
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
	--local printwidth=8
	if not m.back then
		for i=1,#m.text do
			local printwidth=80
			local xoff=320
			local points={}
			
			local arrowx,arrowy=m.x-180,m.y
			local arrowlength=30

			local mapx=g.player.x
			local mapy=g.player.y
			if m.menu_function_args[i][2]<mapx then
				xoff=220
				mapx=mapx-1
				points={m.x-m.w/8-xoff,m.y-40}
			elseif m.menu_function_args[i][2]>mapx then
				xoff=220
				mapx=mapx+1
				points={m.x+m.w/8-xoff,m.y-40}
			elseif m.menu_function_args[i][3]<mapy then
				--printwidth=2
				printwidth=300
				mapy=mapy-1
				points={m.x-xoff,m.y-m.h/4}
			elseif m.menu_function_args[i][3]>mapy then
				--printwidth=2
				printwidth=300
				mapy=mapy+1
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
			local c1,c2=m.c1,m.c2
			local l=g.levels[g.map[mapy][mapx]]
			if l.unlock and not g.player.items[l.unlock] then
				c1=EC.black
			end
			--LG.printformat(m.text[i],points[1],points[2],m.w/printwidth,"center",c1,c2,linealpha)
			LG.printformat(m.text[i],points[1],points[2],printwidth,"center",c1,c2,linealpha)
		end
	else
		local printwidth=120
		if m.words_list==true then
			--print("YESSSSSSSSS")
--[[
			for i=5,#g.player.words+4 do
				print(m.text[i])
				LG.printformat(m.text[i],0,10*i,printwidth,"center",m.c1,m.c2,255)
			end
--]]
			if m.text[5] then
				LG.printformat(m.text[5],0,10*5,printwidth,"center",m.c1,m.c2,255)
			end
			for i,v in ipairs(m.text) do
				--print(v)
				LG.printformat(m.text[i],0,450+i*10,640,"center",m.c1,m.c2,255)
			end
		elseif not m.wordlearned then
			if m.text.index==1 then
				LG.printformat(m.text[1],m.x-m.w/8-140,m.y-40,printwidth,"center",m.c1,m.c2,255)
			else
				LG.printformat(m.text[1],m.x-m.w/8-140,m.y-40,printwidth,"center",m.c1,m.c2,50)
			end
		elseif not m.transition then
			LG.printformat(m.text[1],0,m.y,g.width,"center",m.c1,m.c2,255)
		end
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
						elseif v.locked_colour then
							if i>=v.first and i<=v.last then
								if v.locked_colour=="black" then
									colour={0,0,0}
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
		if not m.wordlearned then
			LG.printf(colourtext,300,700,g.width/2,"left")
		else
			LG.printf(colourtext,0,450,g.width,"center")
		end
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