local function make(x,y)
	local cursor = {}
	cursor.x=x
	cursor.y=y
	return cursor
end

local function update(cursor)
	if cursor then
		local g=Game
		local mx,my=love.mouse.getPosition()
		cursor.x, cursor.y = mx/(g.screen.width/g.width), my/(g.screen.height/g.height)
	end
end

local function draw(cursor,snap)
	if cursor then
		local g=Game
		local xoff,yoff=g.tile.width/2,g.tile.height/2
		if g.t==Enums.games.offgrid then
			LG.setColor(g.palette[EC.red])
			LG.rectangle("line",(cursor.x*g.tile.width),(cursor.y*g.tile.height),g.tile.width,g.tile.height)
			LG.setColor(g.palette[EC.pure_white])
		else
			LG.rectangle("line",cursor.x-xoff,cursor.y-yoff,g.tile.width,g.tile.height)
			--LG.setColor(g.palette[EC.pure_white])
		end
	end
end

return
{
	make = make,
	update = update,
	draw = draw,
}