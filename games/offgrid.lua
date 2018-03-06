local offgrid={}

offgrid.make = function(g)
	local ww,wh=640,640
	g.window={}
	g.window.width=640
	g.window.height=960

	g.bufferscale=(ww/g.tile.width)/wh
	--g.canvas.buffer = LG.newCanvas(ww*g.bufferscale,wh*g.bufferscale)

	g.chars={}
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

	level.load(g,"games/offgrid/levels","json")

	offgrid.loadimages(g)
	--debugger.printtable(g)
	--debugger.printtable(_G)--NOTE DON'T DO THIS! gets stuck in loop printing forever, because _G is a member of _G
end

offgrid.level={}
offgrid.level.city =
{
	make = function(g,l)
		local m={}
		m.text={}
		m.arguments={}
		m.functions={}
		
		offgrid.level.makemenuoption(g,m,g.player.x,g.player.y-1,"North",1)
		offgrid.level.makemenuoption(g,m,g.player.x+1,g.player.y,"East",2)
		offgrid.level.makemenuoption(g,m,g.player.x,g.player.y+1,"South",3)
		offgrid.level.makemenuoption(g,m,g.player.x-1,g.player.y,"West",4)

		module.make(l,EM.menu,EMM.interactive_fiction,320,800,640,320,m.text,EC.white,EC.dark_gray,"left",m.functions,m.arguments)
		--local args={l,EM.menu,EMM.interactive_fiction,320,800,640,320,m.text,EC.white,EC.dark_gray,"left",m.functions,m.arguments}
		--module.make(l,EM.transition,easing.linear,"transition_timer",0,1,240,module.make,args,EM.transitions.screen_transition_blocksreverse)
		module.make(l,EM.transition,easing.linear,"transition_timer",0,1,240,nil,nil,EM.transitions.screen_transition_blocksreverse)

		module.make(l,EM.synth,"sinus",440,60,{"A","B","C","D","E","F","F","G",})
	end,

	control = function(g,l)
	end,

	draw = function(g,l)
		local images=g.images[g.levels.index]
		local animspeed=30
		if g.level.animspeed then
			animspeed=g.level.animspeed
		end
		local anim=math.floor((g.timer/animspeed)%#images)
		LG.draw(images[1+anim],0,0)
	end
}

offgrid.level.make = function(g,l,index)
	g.timer=0

	supper.run(offgrid,{"level",l.t,"make"},g,l)

	if l.description then
		l.menu.description=l.description
		module.make(l.menu,EM.transition,easing.linear,"text_trans",0,string.len(l.menu.description),360)
	end
end

offgrid.level.control = function(g,l)
	if not l.transition then
		if l.menu then
			menu.control(l.menu,1)
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

offgrid.level.makemenuoption = function(g,m,x,y,dir,index)
--checks if a point on the map has a level in it
--if so, puts that in the menu as an option
	if g.map[y] then
		if g.map[y][x] then	
			local value=g.map[y][x]
			if g.levels[value] then
				local destination=g.levels[value].title
				table.insert(m.text,"Go "..dir.." to "..destination)

				table.insert(m.functions,offgrid.move)
				table.insert(m.arguments,{g,x,y})
			end
		end
	end
end

offgrid.gameplay =
{
	make = function(g)
		g.map=map.generate("increment",10,10)
		g.player={}
		g.player.x=1
		g.player.y=1
		--g.levels.index=g.map[g.player.y][g.player.x]
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
	keypressed = function(g,key)
		if key=="space" or key=="return" then
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
		LG.print("offgrid title", g.width/2, g.height/2)
	end
}

offgrid.intro =
{
	keypressed = function(g,key)
		if key=="space" or key=="return" then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" or button=="a" then
			game.state.make(g,"title")
		end
	end,

	draw = function(g)
		LG.print("offgrid intro", g.width/2, g.height/2)
	end
}

offgrid.loadimages = function(g)
	local dir="images/offgrid"
	local buffer = LG.newCanvas(640*g.bufferscale,640*g.bufferscale)
	g.images={}

	local files = love.filesystem.getDirectoryItems(dir) --get all the files+directories in working dir
	for j=1,#files do
		local fileordir=files[j]
		local imagedir=dir.."/"..fileordir
		if love.filesystem.isDirectory(imagedir) then --if it's a dir, then load the images fromt he dir
			g.images[j]={}
			local imagefiles=love.filesystem.getfiles(imagedir,"jpg")
			--for i,v in ipairs(imagefiles) do
			for i=#imagefiles,1,-1 do --TODO this decrements because getfiles() decrements, don't know why, will have to change that
				local v=imagefiles[i]
				local plainimage=LG.newImage(v)
				table.insert(g.images[j],LG.textify(plainimage,g.bufferscale,g.chars,buffer,g.canvas.main,g.tile.width,g.tile.height))
			end
		end
	end
	--debugger.printtable(g.images)
end

offgrid.move = function(g,x,y)
	g.player.x,g.player.y=x,y
	--g.levels.index=g.map[y][x]
	local levelindex=g.map[y][x]
	print(levelindex)
	level.make(g,levelindex)
end

return offgrid