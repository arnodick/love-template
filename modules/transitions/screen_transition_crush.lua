local function make(g,a,m)
	local gw=640
	local gh=640
	m.blocks={}
	m.remove=true
	local blocks={}
	local blockamount=4
	for y=1,blockamount do
		for x=1,blockamount do
			table.insert(blocks,{x=(x-1)*gw/blockamount,y=(y-1)*gh/blockamount,w=gw/blockamount,h=gh/blockamount})
		end
	end
	while #blocks>0 do
		local randblockindex=love.math.random(#blocks)
		table.insert(m.blocks,blocks[randblockindex])
		table.remove(blocks,randblockindex)	
	end
	print("blocks: "..#m.blocks)
	g.clear=false
end

local function control(a,m)
	--print(a.transition_timer)
end

local function draw(g,l,m)
	local imgdata=g.canvas.main:newImageData()
	--imgdata:mapPixel(pixelmaps.melt)
	imgdata:mapPixel(pixelmaps.sparkle)
	imgdata:mapPixel(pixelmaps.crush)
	LG.setCanvas(g.canvas.main) --sets drawing to the primary canvas but does NOT refresh every frame
		local image=LG.newImage(imgdata)
		love.graphics.draw(image,0,0,0,1,1,0,0,0,0)
	LG.setCanvas() --sets drawing back to screen
end

return
{
	make = make,
	control = control,
	draw = draw,
}