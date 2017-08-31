local function make(g)
	g.char="x"

	g.switch=false
	--g.cursor=cursor.make(0,0)
	g.images={}
	g.images.index=1
	table.insert(g.images,LG.newImage("images/band.jpg"))
	table.insert(g.images,LG.newImage("images/bldg.jpg"))
	table.insert(g.images,LG.newImage("images/015.jpg"))
	table.insert(g.images,LG.newImage("images/photo.jpg"))
	table.insert(g.images,LG.newImage("images/large.jpg"))
	table.insert(g.images,LG.newImage("images/ss.jpg"))
	table.insert(g.images,LG.newImage("images/walk.jpg"))
	table.insert(g.images,LG.newImage("images/forestimage.jpg"))
	table.insert(g.images,LG.newImage("images/car320.png"))
	table.insert(g.images,LG.newImage("images/woodland-320-x-320.jpg.png"))
	table.insert(g.images,LG.newImage("images/blue-lagoon-320x320.jpg"))
	table.insert(g.images,LG.newImage("images/church1.jpg"))
	table.insert(g.images,LG.newImage("images/church2.jpg"))
	table.insert(g.images,LG.newImage("images/greeny.jpg"))
	table.insert(g.images,LG.newImage("images/twisted.jpg"))
	table.insert(g.images,LG.newImage("images/corridor.jpg"))
	table.insert(g.images,LG.newImage("images/image14781.jpg"))
	module.make(g,EM.menu,EMM.text,320,800,640,320,"Where are you going...",EC.white,EC.dark_gray)
end

local function control(g)

end

local function keypressed(g,key)
	if key=="space" or key=="return" then
		--game.state.make(g,Enums.games.states.gameplay,Enums.games.modes.roguelike)
	elseif key=='escape' then
		game.state.make(g,Enums.games.states.intro)
	elseif key=='left' then
		g.cursor.x=g.cursor.x-1
	elseif key=='right' then
		g.cursor.x=g.cursor.x+1
	elseif key=='up' then
		g.cursor.y=g.cursor.y-1
	elseif key=='down' then
		g.cursor.y=g.cursor.y+1
	elseif key=='z' then
		g.images.index=g.images.index-1
	elseif key=='x' then
		g.images.index=g.images.index+1
	end
	--g.cursor.x=math.clamp(g.cursor.x,0,#g.images,true)
	--g.images.index=math.clamp(g.images.index,1,#g.images,true)
	g.images.index=math.clamp(g.images.index,1,#g.images,true)
end

local function gamepadpressed(g,button)
	if button=="b" then
		game.state.make(g,Enums.games.states.intro)
	elseif button=="a" then
		g.switch = not g.switch
--[[
		local ps=Screen.pixelscale
		local pixelscaletarget=0.125
		local duration=120
		if ps>=1 then
			module.make(Screen,EM.transition,easing.linear,"pixelscale",ps,-(ps-pixelscaletarget),duration)
		else
			module.make(Screen,EM.transition,easing.linear,"pixelscale",ps,(1-ps),duration)
		end
--]]
	end
end

local function draw(g)
--[[
	local cellw=g.width/g.tile.width
	local cellh=g.height/g.tile.height
	local offset=5
	--LG.print("text title", g.width/2, g.height/2)
	for y=0,cellw do
		for x=0,cellh do
			LG.setColor(g.palette[((x+y-offset)%16)+1])
			LG.print(g.char,x*g.tile.width,y*g.tile.height)
		end
	end
--]]
	LG.setCanvas(g.canvas.window)
		LG.draw(g.images[g.images.index],0,0)
	LG.setCanvas(g.canvas.main)
	if g.cursor then
		cursor.draw(g.cursor)
	end
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}