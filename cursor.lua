local function make(x,y)
	local cursor = {}
	cursor.x=x
	cursor.y=y
	return cursor
end

local function update(cursor)
	if cursor then
		local mx,my=love.mouse.getPosition()
		cursor.x, cursor.y = mx/(Screen.width/Game.width), my/(Screen.height/Game.height)
	end
end

local function draw(cursor,snap)
	if cursor then
		local xoff,yoff=Game.tile.width/2,Game.tile.height/2
		love.graphics.rectangle("line",cursor.x-xoff,cursor.y-yoff,Game.tile.width,Game.tile.height)
		love.graphics.setColor(Palette[Enums.colours.pure_white])
	end
end

return
{
	make = make,
	update = update,
	draw = draw,
}