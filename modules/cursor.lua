local cursor={}
cursor.reticle={}
cursor.editor={}

cursor.make = function(a,c,t,snap)
	local g=Game
	c.t=t
	c.x=g.camera.x
	c.y=g.camera.y
	c.snap=snap or false
	-- print("Yes")
	game.state.run("cursor",c.t,"make",c)
end

cursor.control = function(g,c,a)
	game.state.run("cursor",c.t,"control",g,c,a)
end

cursor.mousepressed = function(g,c,x,y,button)
	if c.t then
		cursor[c.t].mousepressed(g,c,x,y,button)
	end
end

cursor.mousemoved = function(g,c,x,y,dx,dy)
	c.x=math.clamp(c.x+dx,g.camera.x-g.width/2,g.camera.x+g.width/2)
	c.y=math.clamp(c.y+dy,g.camera.y-g.height/2,g.camera.y+g.height/2)
	game.state.run("cursor",c.t,"mousemoved",g,c,x,y,dx,dy)
end

cursor.wheelmoved = function(g,c,x,y)
	if c.t then
		cursor[c.t].wheelmoved(g,c,x,y)
	end
end

cursor.draw = function(c)
	if c.t then
		cursor[c.t].draw(c)
	end
end

cursor.reticle.control = function(g,c,a)
	c.x=c.x+a.vec[1]*a.vel*a.speed
	c.y=c.y-a.vec[2]*a.vel*a.speed
end

cursor.reticle.draw = function(c)
	-- LG.rectangle("fill",c.x-4,c.y-4,16,16)
	LG.draw(Sprites[1].spritesheet,Sprites[1].quads[254],c.x-4,c.y-4)
end

cursor.editor.make = function(c)
	c.value=1
end

cursor.editor.mousepressed = function(g,c,x,y,button)
	if button==1 then
		map.setcellvalue(g.level.map,c.x,c.y,c.value,true)
		c.draw=true
	elseif button==2 then
		-- local map.getcellflags
		map.setcellflag(g.level.map,c.x,c.y,EF.solid,true)
	elseif button==3 then
		map.erasecellflags(g.level.map,c.x,c.y,true)
	end
end

cursor.editor.mousemoved = function(g,c,x,y,dx,dy)
	c.x=math.clamp(c.x,0,g.level.map.width)
	c.y=math.clamp(c.y,0,g.level.map.height)
end

cursor.editor.wheelmoved = function(g,c,x,y)
	local m=g.level.modename
	local min,max=0,255--TODO maybe just make this 127?
	if m=="roguelike" then
		max=127
	end
	c.value=math.clamp(c.value+y,min,max)
end

--TODO input Game into this
cursor.editor.draw = function(c)
	local g=Game
	local l=g.level
	local m=g.level.map
	local tw,th=m.tile.width,m.tile.height

	local cx,cy=c.x,c.y
	local cell=map.getcellvalue(g.level.map,c.x,c.y)
	if c.snap then
		cx,cy=map.getcellcoords(g.level.map,c.x,c.y)
		cx,cy=(cx-1)*tw,(cy-1)*th
	end

	if c.draw==true then
		LG.setCanvas(g.level.canvas.background)
			local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
			LG.translate(xcamoff,ycamoff)
				LG.draw(Sprites[1].spritesheet,Sprites[1].quads[c.value],cx,cy)
			LG.translate(-xcamoff,-ycamoff)
		LG.setCanvas(g.canvas.main)
		c.draw=false
	end
	for i,v in ipairs(EF) do
		LG.setColor(g.palette["white"])
		if flags.get(map.getcellflags(m,c.x,c.y),i) then
			LG.setColor(g.palette["red"])
		end
		LG.points(cx+i*2,cy-5)
	end
	LG.print(c.value,cx+tw,cy+th)
	-- LG.draw(Sprites[1].spritesheet,Sprites[1].quads[c.value],cx,cy)
	if l.modename=="roguelike" then
		LG.print(string.char(c.value),cx,cy)--for printing ascii characters
	else
		LG.draw(Sprites[1].spritesheet,Sprites[1].quads[c.value],cx,cy)
	end

	local p=g.palette["red"]
	p[4]=180--TODO this colour changey
	LG.setColor(p)
	LG.draw(Sprites[1].spritesheet,Sprites[1].quads[254],cx,cy)
	LG.setColor(g.palette["pure_white"])
end

return cursor