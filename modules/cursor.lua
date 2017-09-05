local function make(a,cursor,t,snap)
	cursor.t=t
	cursor.x=0
	cursor.y=0
	cursor.snap=snap or false

	if _G[EM.cursors[cursor.t]]["make"] then
		_G[EM.cursors[cursor.t]]["make"](cursor)
	end
end

local function update(cursor)
	cursor.x,cursor.y=love.mouse.getPosition()
end

local function draw(cursor)
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

return
{
	make = make,
	update = update,
	draw = draw,
}