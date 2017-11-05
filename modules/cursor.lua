local cursor={}

cursor.make = function(a,cursor,t,snap)
	local g=Game
	cursor.t=t
	local x,y=g.camera.x,g.camera.y
	love.mouse.setPosition(x,y)
	cursor.x=x
	cursor.y=y
	cursor.snap=snap or false

	if _G[EM.cursors[cursor.t]]["make"] then
		_G[EM.cursors[cursor.t]]["make"](cursor)
	end
end

cursor.update = function(cursor)
	local g=Game
	local x,y=love.mouse.getPosition()
	x=math.clamp(x,0,g.width-1)
	y=math.clamp(y,0,g.height-1)
	love.mouse.setPosition(x,y)
	cursor.x,cursor.y=x,y
end

cursor.draw = function(cursor)
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

	if _G[EM.cursors[cursor.t]]["draw"] then
		_G[EM.cursors[cursor.t]]["draw"](cursor)
	end
end

return cursor