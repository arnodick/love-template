local function make(cursor)
	cursor.value=1
end

local function draw(cursor)
	local g=Game
	local tw,th=g.tile.width,g.tile.height
	LG.setColor(g.palette[EC.red])
	if cursor.snap then
		local cx,cy=math.floor(cursor.x/tw)*tw,math.floor(cursor.y/th)*th
		LG.print(cursor.value,cx,cy)
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