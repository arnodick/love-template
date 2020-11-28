local roaddrivin={}

roaddrivin.make = function(g)

end

roaddrivin.level={}
roaddrivin.level.country = {
	make = function(g,l)
		local centrex,centrey=g.width/2,g.height/2
		local amount=love.math.random(12,20)
		local dirs={}
		-- table.insert(dirs,0)
		for i=1,amount do
			-- local dist=love.math.random(50,300)
			table.insert(dirs,math.randomfraction(math.pi*2))
		end
		table.sort(dirs)
		l.p={}
		for i,v in ipairs(dirs) do
			local dist=love.math.random(20,100)
			-- local dist=100
			table.insert(l.p,{x=math.round(centrex+math.cos(v)*dist),y=math.round(centrey+math.sin(v)*dist)})
		end
		table.insert(l.p,l.p[1])
		-- l.p={
		-- 	{x=50,y=50},
		-- 	{x=250,y=66},
		-- 	{x=199,y=137},
		-- 	{x=206,y=219},
		-- 	{x=45,y=193},
		-- 	{x=50,y=50}
		-- }
		l.i=1
		l.destx,l.desty=l.p[l.i].x,l.p[l.i].y
		-- l.rand=0
		-- l.dist=1
	end,

	control = function(g,l)
		if l.bgdraw then
			-- local dist=vector.distance(l.destx,l.desty,l.p[l.i+1].x,l.p[l.i+1].y)
			local dir=vector.direction(vector.components(l.destx,l.desty,l.p[l.i+1].x,l.p[l.i+1].y))
			local rand=math.randomfraction(math.pi/2)
			rand=rand*math.choose(-1,1)
			local vecx,vecy=math.cos(dir+rand),math.sin(dir+rand)
			l.destx,l.desty=l.destx+vecx,l.desty+vecy
			-- print(l.destx,l.desty)
			
			if math.round(l.destx)==l.p[l.i+1].x and math.round(l.desty)==l.p[l.i+1].y then
				if l.i<#l.p-1 then
					l.i=l.i+1
				else
					l.bgdraw=false
				end
				-- l.rand=0
				-- l.p[l.i].x,l.p[l.i].y=l.destx,l.desty
				-- l.destx,l.desty=l.p[l.i].x,l.p[l.i].y
				-- l.dist=1
			end
			-- local dist=vector.distance(l.p[l.i].x,l.p[l.i].y,l.p[l.i+1].x,l.p[l.i+1].y)
			-- local dir=vector.direction(vector.components(l.p[l.i].x,l.p[l.i].y,l.p[l.i+1].x,l.p[l.i+1].y))
			-- local vecx,vecy=math.cos(dir),math.sin(dir)
			-- l.rand=l.rand+love.math.random(-1,1)
			-- l.destx,l.desty=l.p[l.i].x+l.dist*vecx,l.p[l.i].y+l.dist*vecy
			-- if (dir>=-math.pi/4 and dir<math.pi/4) or (dir>=math.pi*3/4 and dir<math.pi+math.pi*1/4) then
			-- 	l.desty=l.desty+l.rand	
			-- else
			-- 	l.destx=l.destx+l.rand
			-- end
			
			-- if l.dist<dist then
			-- 	l.dist=l.dist+1
			-- elseif l.i<#l.p-1 then
			-- 	l.i=l.i+1
			-- 	l.rand=0
			-- 	l.p[l.i].x,l.p[l.i].y=l.destx,l.desty
			-- 	-- l.destx,l.desty=l.p[l.i].x,l.p[l.i].y
			-- 	l.dist=1
			-- else
			-- 	l.bgdraw=false
			-- end
		end
	end,

	draw = function(g,l)
		if l then
			if l.bgdraw==true then
				if l.canvas then
					if l.canvas.background then
						LG.setCanvas(l.canvas.background)
						-- local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
						-- LG.translate(xcamoff,ycamoff)

						LG.setColor(g.palette["red"])
						love.graphics.points(l.destx,l.desty)
						-- local p={
						-- 	{x=50,y=50},
						-- 	{x=250,y=66},
						-- 	{x=199,y=137},
						-- 	{x=206,y=219},
						-- 	{x=45,y=193},
						-- 	{x=50,y=50}
						-- }
						-- for i=1,#p-1 do
						-- 	print("X1: "..p[i].x.." Y1: "..p[i].y.." X2: "..p[i+1].x.." Y2: "..p[i+1].y)
						-- 	local dist=vector.distance(p[i].x,p[i].y,p[i+1].x,p[i+1].y)
						-- 	print("DISTANCE: "..dist)
						-- 	local dir=vector.direction(vector.components(p[i].x,p[i].y,p[i+1].x,p[i+1].y))
						-- 	print("DIRECTION: "..dir)
						-- 	local vecx,vecy=math.cos(dir),math.sin(dir)
						-- 	print("VECX: "..vecx)
						-- 	print("VECY: "..vecy)
						-- 	local rand=0
						-- 	local destx,desty=p[i].x,p[i].y
						-- 	for d=1,dist do
						-- 		rand=rand+love.math.random(-1,1)
						-- 		destx,desty=p[i].x+d*vecx,p[i].y+d*vecy
						-- 		if (dir>=-math.pi/4 and dir<math.pi/4) or (dir>=math.pi*3/4 and dir<math.pi+math.pi*1/4) then
						-- 			desty=desty+rand	
						-- 		else
						-- 			destx=destx+rand
						-- 		end
						-- 		love.graphics.points(destx,desty)
						-- 	end
						-- 	print("\nFINAL DEST X: "..math.round(destx).." Y: "..math.round(desty))
						-- 	print("EXPECTED DEST X: "..p[i+1].x.." Y: "..p[i+1].y.."\n")
						-- 	-- love.graphics.line(p[i].x,p[i].y,p[i+1].x,p[i+1].y)
						-- end
					--TODO use vectors here
						-- local xx,yy=50,50
						-- local x2,y2=50
						-- for i=1,100 do
						-- 	love.graphics.points(xx,yy)
						-- 	xx=xx+1
						-- 	yy=yy+love.math.random(-1,1)
						-- end
						-- LG.translate(-xcamoff,-ycamoff)--TODO why?
					end
				end
				LG.setCanvas(g.canvas.main)
				-- l.bgdraw=false
			end
			local imgdata=l.canvas.background:newImageData()
			imgdata:mapPixel(pixelmaps.sparkle)
			local image=LG.newImage(imgdata)
			LG.setCanvas(l.canvas.background)
				love.graphics.draw(image,0,0,0,1,1,0,0,0,0)
			LG.setCanvas(g.canvas.main)
		end
	end
}

roaddrivin.level.make = function(g,l)
	roaddrivin.level[l.t].make(g,l)
end

roaddrivin.level.control = function(g,l)
	roaddrivin.level[l.t].control(g,l)
end

roaddrivin.level.draw = function(g,l)
	--TODO should this go in game.draw? ie gamename.level.type.draw
	roaddrivin.level[l.t].draw(g,l)
end

roaddrivin.gameplay =
{
	make = function(g)
		--TODO just do this, take map generators, args, drawmodes out of level json file
		--map.generate(g.map,"country",{arguyments here})
		level.make(g,1,Enums.modes.topdown)
		-- local m=g.level.map
		-- actor.make(g,EA.roaddrivin_actor,m.width/2-5,m.height/2-5)
	end,

	keypressed = function(g,key)
		local ease=easing.outElastic
		local dist=300
		local d=300
		if key=='escape' then
			game.state.make(g,"title")
		elseif key=='z' then
			module.make(g,g.camera,EM.transition,ease,"zoom",g.camera.zoom,4,d)
		elseif key=='x' then
			module.make(g,g.camera,EM.transition,ease,"zoom",g.camera.zoom,-4,d)
		end
	end,

	draw = function(g)

	end
}

roaddrivin.title =
{
	keypressed = function(g,key)
		if game.keyconfirm(key) then
			game.state.make(g,"gameplay")
		elseif key=='escape' then
			game.state.make(g,"intro")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" or button=="a" then
			game.state.make(g,"gameplay")
		end
		if button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.print("TITLE", g.width/2, g.height/2)
	end
}

roaddrivin.intro =
{
	keypressed = function(g,key)
		if game.keyconfirm(key) then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" or button=="a" then
			game.state.make(g,"title")
		end
	end,

	draw = function(g)
		LG.print("INTRO", g.width/2, g.height/2)
	end
}

roaddrivin.option =
{
	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.print("OPTION",g.width/2,g.height/2)
	end
}

return roaddrivin