local cursor={}
cursor.reticle={}
cursor.editor={}

cursor.make = function(a,c,t,snap)
	local g=Game
	c.t=t
	c.x=g.camera.x
	c.y=g.camera.y
	c.snap=snap or false
	print("Yes")
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
	c.x,c.y=c.x+dx,c.y+dy
	c.x=math.clamp(c.x,g.camera.x-g.width/2+8,g.camera.x+g.width/2)
	c.y=math.clamp(c.y,g.camera.y-g.height/2+8,g.camera.y+g.height/2)
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
	LG.draw(Spritesheet[1],Quads[1][254],c.x-4,c.y-4)
end

cursor.editor.make = function(c)
	c.value=1
end

cursor.editor.mousepressed = function(g,c,x,y,button)
	if button==1 then
		map.setcellvalue(g.level.map,c.x,c.y,c.value,true)
		c.draw=true
	elseif button==2 then
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
	c.value=math.clamp(c.value+y,0,255)--TODO make this limit more dynamic?
end

--TODO input Game into this
cursor.editor.draw = function(c)
	local g=Game
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
				LG.draw(Spritesheet[1],Quads[1][c.value],cx,cy)
			LG.translate(-xcamoff,-ycamoff)
		LG.setCanvas(g.canvas.main)
		c.draw=false
	end
	for i=1,#Enums.flags do
		LG.setColor(g.palette[EC.white])
		if flags.get(cell,i,16) then
			LG.setColor(g.palette[EC.red])
		end
		LG.points(cx+i*2,cy-5)
	end
	LG.print(c.value,cx+tw,cy+th)
	LG.draw(Spritesheet[1],Quads[1][c.value],cx,cy)

	local p=g.palette[EC.red]
	p[4]=180
	LG.setColor(p)
	LG.draw(Spritesheet[1],Quads[1][254],cx,cy)
	LG.setColor(g.palette[EC.pure_white])
end

return cursor