local function make(x,y,snap)
	local cursor = {}
	cursor.x=x
	cursor.y=y
	cursor.snap=snap or false
	return cursor
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
			LG.rectangle("line",math.ceil((cursor.x)/tw+1)*tw-xoff,math.ceil((cursor.y)/th+1)*th-yoff,tw,th)
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