local cursor={}

cursor.make = function(a,c,t,snap)
	local g=Game
	c.t=t
	local x,y=g.camera.x,g.camera.y
	love.mouse.setPosition(x,y)
	c.x=x
	c.y=y
	c.snap=snap or false

	if c.t then
		cursor[c.t].make(c)
	end
end

cursor.update = function(c)
	local g=Game
	local x,y=love.mouse.getPosition()
	x=math.clamp(x,0,map.width(g.level.map))
	y=math.clamp(y,0,map.height(g.level.map))
	love.mouse.setPosition(x,y)
	c.x,c.y=x,y
end

cursor.mousepressed = function(g,c,x,y,button)
	if c.t then
		cursor[c.t].mousepressed(g,c,x,y,button)
	end
end

cursor.draw = function(c)
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
	if c.t then
		cursor[c.t].draw(c)
	end
end

cursor.editor={}

cursor.editor.make = function(c)
	c.value=1
end

cursor.editor.mousepressed = function(g,c,x,y,button)
	if button==1 then
		map.setcellvalue(g.level.map,c.x,c.y,c.value,true)
	elseif button==2 then
		map.setcellflag(g.level.map,c.x,c.y,EF.solid,true)
	end
end

--TODO input Game into this
cursor.editor.draw = function(c)
	local g=Game
	local tw,th=g.tile.width,g.tile.height
	--LG.setColor(g.palette[EC.red])
	if c.snap then
		local cx,cy=map.getcell(g.level.map,c.x,c.y)
		--local cell=Game.level.map[cy][cx]
		local cell=map.getcellvalue(g.level.map,c.x,c.y)
--[[
		if flags.get(cell,EF.solid,16) then
			LG.setColor(g.palette[EC.red])
		end
--]]
		--cx,cy=math.floor(c.x/tw)*tw,math.floor(c.y/th)*th
		cx,cy=(cx-1)*tw,(cy-1)*th
		for i=1,11 do
			LG.setColor(g.palette[EC.white])
			if flags.get(cell,i,16) then
				LG.setColor(g.palette[EC.red])
			end
			LG.points(cx-i*2,cy-5)
		end
		LG.print(c.value,cx+tw,cy+th)
		LG.draw(Spritesheet[1],Quads[1][c.value],cx,cy)

		local p=g.palette[EC.red]
		p[4]=180
		LG.setColor(p)
		if c.snap then
			--local cx,cy=math.floor(c.x/tw)*tw+1,math.floor(c.y/th)*th+1
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
			LG.rectangle("line",c.x-tw,c.y-th,tw,th)
		end
	else
		LG.print(c.value,c.x,c.y)
	end
	LG.setColor(g.palette[EC.pure_white])
end

return cursor