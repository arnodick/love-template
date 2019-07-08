local offgrid={}

offgrid.make = function(g)
	local ww,wh=640,640
	g.window={}
	g.window.width=640
	g.window.height=960
	g.tile={}
	g.tile.width=8
	g.tile.height=8
	g.titlefont=LG.newFont("fonts/Kongtext Regular.ttf",20)

	g.bufferscale=(ww/g.tile.width)/wh

	g.chars={}
	table.insert(g.chars," ")
	table.insert(g.chars,"█")
	table.insert(g.chars,"█")
	table.insert(g.chars,"█")
	table.insert(g.chars,"█")
	table.insert(g.chars,"█")
	table.insert(g.chars,"█")
	table.insert(g.chars,"█")
	table.insert(g.chars,"█")
	table.insert(g.chars,"█")
	table.insert(g.chars,"█")
--[[
	table.insert(g.chars," ")
	table.insert(g.chars,"\\")
	table.insert(g.chars,"/")
	--table.insert(g.chars,",")
	--table.insert(g.chars,":")
	table.insert(g.chars,"-")
	table.insert(g.chars,"-")
	table.insert(g.chars,"-")
	--table.insert(g.chars,"=")
	--table.insert(g.chars,"+")
	--table.insert(g.chars,"*")
	table.insert(g.chars,"/")
	table.insert(g.chars,"|")
	table.insert(g.chars,"\\")
	--table.insert(g.chars,"#")
	--table.insert(g.chars,"@")
	table.insert(g.chars,"_")
	table.insert(g.chars,"~")
--]]

	local images=library.load("images/offgrid","jpg")
	g.images={}
	local buffer=LG.newCanvas(640*g.bufferscale,640*g.bufferscale)
	offgrid.convertimages(g,g.images,images,buffer)
	supper.print(g.images)
	--supper.print(_G)--NOTE DON'T DO THIS! gets stuck in loop printing forever, because _G is a member of _G
end

offgrid.level={}
offgrid.level.city =
{
	make = function(g,l)
		local m={}
		m.text={}
		m.arguments={}
		m.functions={}
		
		if l.back then
			offgrid.level.makebackoption(g,m,l.back)
		elseif not l.no_back then
			offgrid.level.makemoveoption(g,m,g.player.x,g.player.y-1,"North",1)
			offgrid.level.makemoveoption(g,m,g.player.x+1,g.player.y,"East",2)
			offgrid.level.makemoveoption(g,m,g.player.x,g.player.y+1,"South",3)
			offgrid.level.makemoveoption(g,m,g.player.x-1,g.player.y,"West",4)
		end

		--module.make(l,EM.menu,EMM.interactive_fiction,320,800,640,320,m.text,"white","dark_gray","left",m.functions,m.arguments)
		if l.options then
			if not (l.unlock_description and g.player.items[l.unlock_description_item]) then
				for i,v in ipairs(l.options) do
					if v.unlock then
						if g.player.items[v.unlock] then
							offgrid.level.makeinspectoption(g,m,l.options[i].name,4+i,l.options[i].game_name)
						end
					else
						offgrid.level.makeinspectoption(g,m,l.options[i].name,4+i,l.options[i].game_name)
					end
				end
			end
		end
		module.make(l,EM.menu,"interactive_fiction",320,800,640,320,m.text,"white","dark_gray","left",m.functions,m.arguments)
		if l.selected_index then
			l.menu.text.index=l.selected_index
		end
		if l.options then
			if not (l.unlock_description and g.player.items[l.unlock_description_item]) then
				l.menu.options=l.options
				supper.print(l.menu.options)
			end
		end
		if l.back then
			l.menu.back=l.back
		end
		--supper.print(l.menu.options)
		--local args={l,EM.menu,EMM.interactive_fiction,320,800,640,320,m.text,"white","dark_gray","left",m.functions,m.arguments}
		--module.make(l,EM.transition,easing.linear,"transition_timer",0,1,240,module.make,args,EM.transitions.screen_transition_blocksreverse)
		if l.transition_in then
			--module.make(l,EM.transition,easing.linear,"transition_timer",0,1,240,nil,nil,EM.transitions.screen_transition_blocksreverse)
			if l.music then
				module.make(l,EM.transition,easing.linear,"transition_timer",0,1,240,music.play,{l.music},EM.transitions[l.transition_in])
			elseif l.sound then
				print("SOUND MAD")
				module.make(l,EM.transition,easing.linear,"transition_timer",0,1,240,sfx.play,{l.sound},EM.transitions[l.transition_in])
			elseif l.unlock_description and g.player.items[l.unlock_description_item] then
				if l.unlock_sound then
					--sfx.play(l.unlock_sound)
					module.make(l,EM.transition,easing.linear,"transition_timer",0,1,240,sfx.play,{l.unlock_sound},EM.transitions[l.transition_in])
				end
			else
				module.make(l,EM.transition,easing.linear,"transition_timer",0,1,240,nil,nil,EM.transitions[l.transition_in])
			end
			module.make(l,EM.synth,"sinus",440,60,{"A","B","C","D","E","F","F","G",})
		else
			if l.music then
				music.play(l.music)
			elseif l.sound then
				print("SOUND MADEEEE")
				sfx.play(l.sound)
			elseif l.unlock_description and g.player.items[l.unlock_description_item] then
				if l.unlock_sound then
					--sfx.play(l.unlock_sound)
					sfx.play(l.unlock_sound)
				end
			end
		end

		if l.unlock_description and g.player.items[l.unlock_description_item] then
			l.menu.description=l.unlock_description
			module.make(l.menu,EM.transition,easing.linear,"text_trans",0,string.len(l.menu.description),360)
			if l.unlock_item_get then
				if not g.player.items[l.unlock_item_get] then
					print(l.unlock_item_get)
					supper.print(g.player.items)
					g.player.items[l.unlock_item_get]=l.unlock_item_get
					supper.print(g.player.items)
				end
			elseif l.unlock_items_get then
				for i,v in ipairs(l.unlock_items_get) do
					if not g.player.items[v] then
						g.player.items[v]=v
					end
				end
			end
		elseif l.description then
			l.menu.description=l.description
			module.make(l.menu,EM.transition,easing.linear,"text_trans",0,string.len(l.menu.description),360)
		end
		if l.item then
			if not g.player.items[l.item] then
				print(l.item)
				supper.print(g.player.items)
				g.player.items[l.item]=l.item
				supper.print(g.player.items)
			end
		end
	end,

	control = function(g,l)
	end,

	draw = function(g,l)
		local images=g.images[g.levels.index]
		if l.unlock_description_image and g.player.items[l.unlock_description_item] then
			images=g.images[l.unlock_description_image]
		end
		local animspeed=30
		if g.level.animspeed then
			animspeed=g.level.animspeed
		end
		local anim=math.floor((g.timer/animspeed)%#images)
		LG.draw(images[1+anim],0,0)
	end
}

offgrid.level.word =
{
	make = function(g,l)
		sfx.play(20)
		local m={}
		m.text={}
		m.arguments={}
		m.functions={}
		offgrid.level.makebackoption(g,m,l.back)

		module.make(l,EM.menu,"interactive_fiction",320,600,640,320,m.text,"white","dark_gray","center",m.functions,m.arguments)
		l.menu.wordlearned=true
		l.menu.back=l.back
		l.menu.description=l.description
		module.make(l.menu,EM.transition,easing.linear,"text_trans",0,string.len(l.menu.description),360)

		print(l.item)
		supper.print(g.player.words)
		g.player.words[l.word]=l.word
		g.player.items[l.word]=l.word
		supper.print(g.player.words)
	end,

	control = function(g,l)
	end,

	draw = function(g,l)
	end
}

offgrid.level.offgrid =
{
	make = function(g,l)
		--TODO here will maybe be the options that you can go to from here? offgrid areas (usually won't have option to go back, choices of where you can go aren't based on the grid, but are instead linked lists sort of. will need a menu where you can use items, talk to people, etc. more like a story than an exploration)
		module.make(l,EM.menu,EMM.interactive,g.width/2,120,160,50,g.player.words,"orange","dark_green","center")
	end,

	control = function(g,l)
		
	end,

	draw = function(g,l)
		
	end
}

offgrid.level.make = function(g,l,index)
	g.timer=0
	supper.run(offgrid,{"level",l.t,"make"},g,l)
end

offgrid.level.control = function(g,l)
	if not l.transition then
		if l.menu then
			menu.control(g,l.menu,1)
		end
	end
	synth.control(l,l.synth)

--[[
	local saw = denver.get({waveform='sawtooth', frequency="G", length=2})
	--local saw = denver.get({waveform='sawtooth', frequency="G", length=1/60})
	--local saw2 = denver.get({waveform='sawtooth', frequency="B", length=1/60})
	saw:setLooping(false)
	if g.timer==1 then
		love.audio.play(saw)
	end
	if g.timer==31 then
		--love.audio.play(saw2)
	end
--]]
	--local sine = denver.get({waveform='sinus', frequency=440, length=1})
	--love.audio.play(sine)
	--local noise = denver.get({waveform='whitenoise', length=6})
	--love.audio.play(noise)
	offgrid.level[l.t].control(g,l)
end

offgrid.level.keypressed = function(g,l,key)
	local glc = g.level
	if not glc or not glc.transition then
		if l.menu then
			menu.keypressed(l.menu,key)
		end
--[[
		if key=='x' then
			level.make(g,"car")
		end
--]]
	end
end

offgrid.level.keyreleased = function(g,l,key)
	local glc = g.level
	if not glc or not glc.transition then
		if l.menu then
			menu.keyreleased(l.menu,key)
		end
	end
end

offgrid.level.gamepadpressed = function(g,l,button)
	if l.menu then
		menu.gamepadpressed(l.menu,button)
	end
end

offgrid.level.draw = function(g,l)
	if not l.transition then
		if l.menu then
			menu.draw(l.menu)
		end
	end
	offgrid.level[l.t].draw(g,l)
end

offgrid.level.makemoveoption = function(g,m,x,y,dir,index)
--checks if a point on the map has a level in it
--if so, puts that in the menu as an option
	if g.map[y] then
		if g.map[y][x] then	
			local value=g.map[y][x]
			if g.levels[value] then
				local destination=g.levels[value].title
				local make=true
				if g.levels[value].restricted_entry_directions then
					for i,v in ipairs(g.levels[value].restricted_entry_directions) do
						if dir==v then
							print("RESTRICTED")
							make=false
						end
					end
				end
				if make==true then
					--this code sets what the menu option says, what it does, and the parameters for what it does
					table.insert(m.text,"Go "..dir.." to "..destination)
					table.insert(m.functions,offgrid.move)
					table.insert(m.arguments,{g,x,y})
				end
--[[
				m.text[index]="Go "..dir.." to "..destination
				m.functions[index]=offgrid.move
				m.arguments[index]={g,x,y}
--]]
			end
		end
	end
end

offgrid.level.makeinspectoption = function(g,m,name,index,gamename)
--makes an option in the right menu area open an inspect level by its name
	--m.functions[index]=offgrid.inspect
	if gamename then
		m.functions[index]=game.make
		print("GAME MAKE NAME "..gamename)
		m.arguments[index]={Enums.games[gamename]}
	else
		m.functions[index]=level.make
		print("INSPECT OPTION NAME "..name)
		m.arguments[index]={g,name}
	end
	--print("MMMMMMMMM")
	--supper.print(m)
end

offgrid.level.makebackoption = function(g,m,name)
	m.text[1]="Go back to "..g.levels[name].title
	m.functions[1]=level.make
	m.arguments[1]={g,name}
end

offgrid.gameplay =
{
	make = function(g)
		g.map={}
		map.init(g.map,10,10)
		--g.map={w=10,h=10,tile={width=8,height=8}}
		--g.map=map.generate("increment",10,10)
		map.generate(g.map,"increment")
		g.player={}
		g.player.x=5
		g.player.y=5
		g.player.items={}
		--g.player.items["smokestack_knowledge"]="smokestack_knowledge"
		g.player.words={}
		--g.player.words["protosnake"]="protosnake"
		--g.player.items["protosnake"]="protosnake"
		local levelindex=g.map[g.player.y][g.player.x]
		level.make(g,levelindex)
	end,

	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="a" then
			g.switch = not g.switch
		end
	end,

	draw = function (g)
		if Debugger.debugging then
			--LG.print(g.player.x.." "..g.player.y,10,120)
			--LG.print(g.map[g.player.y][g.player.x],10,130)
			LG.print(g.level.menu.text.index,10,140)
		end
	end
}

offgrid.title =
{
	make = function(g)
		g.introstart=true
	end,

	keypressed = function(g,key)
		if key=="z" then
			game.state.make(g,"gameplay")
		elseif key=='escape' then
			game.state.make(g,"intro")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" or button=="a" then
			game.state.make(g,"gameplay")
		elseif button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		if g.introstart==true then
			LG.setFont(g.titlefont)
		end
		--LG.print("ARROWS keys and Z",g.width/2,g.height/2)
		LG.printformat("ARROWS keys and Z",0,800,640,"center","white","dark_gray",100+math.sin(g.timer/10)*100)
	end
}

offgrid.intro =
{
	make = function(g)
		g.introstart=true
		g.drawoffgrid=false
	end,

	control = function(g)
		if g.transition then
			transition.control(g,g.transition)
		end
	end,

	keypressed = function(g,key)
		if key=="z" then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" or button=="a" then
			game.state.make(g,"title")
		end
	end,

	draw = function(g)
		local shakey = function()
			g.screen.shake=40
			g.drawoffgrid=true
		end
		if g.introstart==true then
			g.introstart=false
			sfx.play(22)
			module.make(g,EM.transition,easing.linear,"letter_timer",0,1,100,shakey,{})
		end
		local f=LG.newFont("fonts/Kongtext Regular.ttf",90)
		f:setFilter("nearest","nearest",0) --clean TEXT scaling
		LG.setFont(f)

		local yoff=-200
		--LG.print("offgrid intro", g.width/2, g.height/2)
		LG.print("O",g.width-(g.letter_timer*(g.width-20)),g.height/2+yoff)
		LG.print("N",120,g.height/2*g.letter_timer+yoff)
		LG.print("T",320,g.height-(g.letter_timer*g.height/2)+yoff)
		LG.print("H",g.width-(g.letter_timer*(g.width-420)),g.height/2*g.letter_timer+yoff)
		LG.print("E",520*g.letter_timer,g.height/2*g.letter_timer+yoff)
		LG.print("G",120*g.letter_timer,g.height/2*g.letter_timer+100+yoff)
		LG.print("R",220,g.height-(g.letter_timer*g.height/2)+100+yoff)
		LG.print("I",g.width-(g.letter_timer*(g.width-320)),g.height/2*g.letter_timer+100+yoff)
		LG.print("D",g.width-(g.letter_timer*(g.width-420)),g.height/2+100+yoff)

		if g.drawoffgrid==true then
			LG.setCanvas(g.canvas.buffer)
				LG.clear()
				LG.printformat("OFF THE GRID",0,0,g.width,"center","dark_gray","dark_gray",255)
			LG.setCanvas(g.canvas.main)

			local imgdata=g.canvas.buffer:newImageData(1,1,0,0,640,320)
			local iw,ih=imgdata:getWidth(),imgdata:getHeight()
			--imgdata:mapPixel(pixelmaps.crush)
	
			for x=iw-1,0,-1 do
			    for y=ih-1,0,-1 do
					local xoff=math.clamp(math.floor(x+math.sin(g.timer+y*10)*10),0,iw-1)
					local r,gr,b,a = imgdata:getPixel(x,y)
					imgdata:setPixel(xoff,y,r,gr,b,a)
			    end
			end
			local image=LG.newImage(imgdata)
			love.graphics.draw(image,0,550,0,1,1)

			LG.setFont(g.titlefont)
			LG.printformat("press Z to start",0,800,640,"center","white","dark_gray",100+math.sin(g.timer/10)*100)
		end
	end
}

offgrid.convertimages = function(g,gameimages,images,buffer)
	for index,v in pairs(images) do--loop through all tables and images in images table
		if type(v)=="table" then
			if tonumber(index) then
				index=tonumber(index)
			end
			gameimages[index]={}
			offgrid.convertimages(g,gameimages[index],v,buffer)
		elseif v:typeOf("Image") then
			gameimages[index]=LG.textify(v,g.bufferscale,g.chars,buffer,g.canvas.main,g.tile.width,g.tile.height)
		end
	end
end

offgrid.move = function(g,x,y)
	if g.level.music then
		music.stop(g.level.music)
	end
	g.player.x,g.player.y=x,y
	local levelindex=g.map[y][x]
	print(levelindex)
	level.make(g,levelindex)
end

--[[
offgrid.inspect = function(g,index)
	level.make(g,index)
end
--]]

return offgrid