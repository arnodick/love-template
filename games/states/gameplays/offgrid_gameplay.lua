local function make(g)
	g.switch=false
	g.images={}
	g.images.index=1
	table.insert(g.images,LG.newImage("images/band.jpg"))
	--table.insert(g.images,LG.newImage("images/bldg.jpg"))
	table.insert(g.images,LG.newImage("images/015.jpg"))
	table.insert(g.images,LG.newImage("images/photo.jpg"))
	table.insert(g.images,LG.newImage("images/large.jpg"))
	--table.insert(g.images,LG.newImage("images/ss.jpg"))
	--table.insert(g.images,LG.newImage("images/walk.jpg"))
	table.insert(g.images,LG.newImage("images/forestimage.jpg"))
	--table.insert(g.images,LG.newImage("images/car320.png"))
	--table.insert(g.images,LG.newImage("images/woodland-320-x-320.jpg.png"))
--[[
	table.insert(g.images,LG.newImage("images/blue-lagoon-320x320.jpg"))
	table.insert(g.images,LG.newImage("images/church1.jpg"))
	table.insert(g.images,LG.newImage("images/church2.jpg"))
	table.insert(g.images,LG.newImage("images/greeny.jpg"))
	table.insert(g.images,LG.newImage("images/twisted.jpg"))
	table.insert(g.images,LG.newImage("images/corridor.jpg"))
	table.insert(g.images,LG.newImage("images/image14781.jpg"))
--]]
	module.make(g,EM.menu,EMM.text,320,800,640,320,"Where are you going...",EC.white,EC.dark_gray)

	g.textimages={}
	for i,v in ipairs(g.images) do
		table.insert(g.textimages,LG.textify(v,g.bufferscale,g.chars,g.canvas.buffer,g.canvas.main))
	end
	g.textimages.index=1
end

local function control(g)

end

local function keypressed(g,key)
	if key=='escape' then
		game.state.make(g,Enums.games.states.title)
	elseif key=='z' then
		--g.images.index=g.images.index-1
		g.textimages.index=g.textimages.index-1
	elseif key=='x' then
		--g.images.index=g.images.index+1
		g.textimages.index=g.textimages.index+1
	end
	g.textimages.index=math.clamp(g.textimages.index,1,#g.textimages,true)
end

local function gamepadpressed(g,button)
	if button=="a" then
		g.switch = not g.switch
	end
end

local function draw(g)
	LG.draw(g.textimages[g.textimages.index],0,0)
	if g.menu then
		menu.draw(g.menu)
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