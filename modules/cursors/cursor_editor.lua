local function make(cursor)
	cursor.value=1
end


--TODO input Game into this
local function draw(cursor)
	local g=Game
	local tw,th=g.tile.width,g.tile.height
	--LG.setColor(g.palette[EC.red])
	if cursor.snap then
		local cx,cy=map.getcell(g.level.map,cursor.x+tw,cursor.y+th)
		local cell=Game.level.map[cy][cx]
--[[
		if flags.get(cell,EF.solid,16) then
			LG.setColor(g.palette[EC.red])
		end
--]]
		--cx,cy=math.floor(cursor.x/tw)*tw,math.floor(cursor.y/th)*th
		cx,cy=(cx-2)*tw,(cy-2)*th
		for i=1,11 do
			LG.setColor(g.palette[EC.white])
			if flags.get(cell,i,16) then
				LG.setColor(g.palette[EC.red])
			end
			LG.points(cx-i*2,cy-5)
		end
		LG.print(cursor.value,cx+tw,cy+th)
		LG.draw(Spritesheet[1],Quads[1][cursor.value],cx,cy)

		local p=g.palette[EC.red]
		p[4]=180
		LG.setColor(p)
		if cursor.snap then
			--local cx,cy=math.floor(cursor.x/tw)*tw+1,math.floor(cursor.y/th)*th+1
			--LG.rectangle("line",cx,cy,tw,th)
			LG.line(cx-1,cy,cx+2,cy)
			LG.line(cx,cy,cx,cy+2)
			LG.line(cx+tw,cy,cx+tw-3,cy)
			LG.line(cx+tw,cy,cx+tw,cy+2)
			LG.line(cx,cy+th,cx,cy+th-3)
			LG.line(cx,cy+th,cx+2,cy+th)
			LG.line(cx+tw,cy+th-1,cx+tw,cy+th-3)
			LG.line(cx+tw,cy+th,cx+tw-3,cy+th)
		else
			LG.rectangle("line",cursor.x-tw,cursor.y-th,tw,th)
		end
	else
		LG.print(cursor.value,cursor.x,cursor.y)
	end
	LG.setColor(g.palette[EC.pure_white])
end

return
{
	make = make,
	draw = draw,
}