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
--[[
	local g=Game
	local tw,th=g.tile.width,g.tile.height
	local xoff,yoff=tw,th
	local p=g.palette[EC.red]
	p[4]=180
	LG.setColor(p)
	if cursor.snap then
		local cx,cy=math.floor(cursor.x/tw)*tw+1,math.floor(cursor.y/th)*th+1
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
		LG.rectangle("line",cursor.x-xoff,cursor.y-yoff,tw,th)
	end
	LG.setColor(g.palette[EC.pure_white])
--]]

	if _G[EM.cursors[cursor.t]]["draw"] then
		_G[EM.cursors[cursor.t]]["draw"](cursor)
	end
end

return cursor