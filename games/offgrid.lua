local function make(g,tw,th,gw,gh,sp)
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

	state.make(g,Enums.games.states.intro)
end

local function control(g)
	state.control(g)
end

local function keypressed(g,key,scancode,isrepeat)
	state.keypressed(g,key)
end

local function mousepressed(g,x,y,button)
	state.mousepressed(g,x,y,button)
end

local function wheelmoved(g,x,y)
	state.wheelmoved(g,x,y)
end

local function gamepadpressed(g,button)
	state.gamepadpressed(g,button)
end

local function draw(g)
	state.draw(g)
end

local function loadimages(g)
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

local function move(g,x,y)
	g.player.x,g.player.y=x,y
	g.level=g.map[y][x]
	print(g.level)
	level.make(g,g.level)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	mousepressed = mousepressed,
	wheelmoved = wheelmoved,
	gamepadpressed = gamepadpressed,
	draw = draw,
	loadimages = loadimages,
	move = move,
}