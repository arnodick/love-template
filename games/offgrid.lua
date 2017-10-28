local offgrid={}

offgrid.make = function(g,tw,th,gw,gh,sp)
	local ww,wh=640,640
	g.window={}
	g.window.width=640
	g.window.height=960

	g.bufferscale=(ww/tw)/wh
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

	level.load(g,"games/levels/offgrid/inis")

	offgrid.loadimages(g)

	--game.state.make(g,Enums.games.states.intro)
end

offgrid.gameplay =
{
	make = function(g)
		g.map=map.generate("increment",10,10)
		g.player={}
		g.player.x=1
		g.player.y=1
		g.level=g.map[g.player.y][g.player.x]
		level.make(g,g.level)
	end,

	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,button)
		if button=="a" then
			g.switch = not g.switch
		end
	end,

	draw = function (g)
		if Debugger.debugging then
			--LG.print(g.player.x.." "..g.player.y,10,120)
			--LG.print(g.map[g.player.y][g.player.x],10,130)
			LG.print(g.levels.current.menu.text.index,10,140)
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

	gamepadpressed = function(g,button)
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
		elseif key == 'escape' then
			love.event.quit()
		end
	end,

	gamepadpressed = function(g,button)
		if button=="start" or button=="a" then
			game.state.make(g,"title")
		elseif button=="b" then
			love.event.quit()
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
	debugger.printtable(g.images)
end

offgrid.move = function(g,x,y)
	g.player.x,g.player.y=x,y
	g.level=g.map[y][x]
	print(g.level)
	level.make(g,g.level)
end

return offgrid