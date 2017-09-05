local function make(a,cursor,snap)
	cursor.x=0
	cursor.y=0
	cursor.snap=snap or false
end

local function update(cursor)
	if cursor then
		cursor.x,cursor.y=love.mouse.getPosition()
	end
end

local function draw(cursor)
	if cursor then
		local g=Game
		local tw,th=g.tile.width,g.tile.height
		local xoff,yoff=tw,th
		LG.setColor(g.palette[EC.red])
		if cursor.snap then
			local cx,cy=math.floor(cursor.x/tw)*tw,math.floor(cursor.y/th)*th
			LG.rectangle("line",cx,cy,tw,th)
		else
			LG.rectangle("line",cursor.x-xoff,cursor.y-yoff,tw,th)
		end
		LG.setColor(g.palette[EC.pure_white])
	end
end

return
{
	make = make,
	update = update,
	draw = draw,
}