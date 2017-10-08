local function make(a,m)
	local g=Game
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
end

local function control(a,m)
	--print(a.transition_timer)
end

local function draw(g,l,m)
	LG.setCanvas(g.canvas.main) --sets drawing to the primary canvas but does NOT refresh every frame
		if m.remove then
			if #m.blocks>0 then
				local randblockindex=love.math.random(#m.blocks)
				LG.setColor(g.palette[EC.white])
				LG.rectangle("fill",m.blocks[randblockindex].x,m.blocks[randblockindex].y,m.blocks[randblockindex].w,m.blocks[randblockindex].h)
				LG.setColor(g.palette[EC.pure_white])
				table.remove(m.blocks,randblockindex)
			end
			m.remove=false
		elseif math.floor(l.transition_timer*32)%2==0 then
			m.remove=true
		end
	LG.setCanvas() --sets drawing back to screen
end

return
{
	make = make,
	control = control,
	draw = draw,
}