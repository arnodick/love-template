function make(x,y)
	local cursor = {}
	cursor.x=x
	cursor.y=y
	return cursor
end


function update(cursor)
	if cursor then
		local mx,my=love.mouse.getPosition()
		cursor.x, cursor.y = mx/(Screen.width/Game.width), my/Screen.scale --TODO does this make sense?
		--TODO clamp this to fix crash outside of map bug?
	end
end

function draw(cursor,snap)
	--need to fix this now that fullscreen
	if cursor then
		love.graphics.rectangle("line",cursor.x-1,cursor.y-1,Game.tile.width+2,Game.tile.height+2)
		love.graphics.setColor(Palette[Enums.colours.pure_white])
	end
end

return
{
	make = make,
	update = update,
	draw = draw,
}