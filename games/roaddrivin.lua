local roaddrivin={}

roaddrivin.make = function(g)

end

roaddrivin.fillthing = function(l,imgdata,x,y,dirx,diry)
	local st={{x=x,y=y}}
	local r,gr,b=imgdata:getPixel(st[#st].x-1,st[#st].y-1)
	local rh,grh,bh=imgdata:getPixel(st[#st].x-1+dirx,st[#st].y-1)
	local rv,grv,bv=imgdata:getPixel(st[#st].x-1,st[#st].y-1+diry)

	while #st>0 do
		--if the current pixel is black, draw on it
		if (r==0 and gr==0 and b==0) then
			love.graphics.points(x,st[#st].y)
		end

		--check below current pixel
		-- local nexty=y+diry
		-- r,gr,b=imgdata:getPixel(x-1,nexty-1)

		--if pxiel below current is black, move down to pixel below and start again, put our new point in the stack
		if (rv==0 and grv==0 and bv==0) then
			
			local newy=st[#st].y+diry
			table.insert(st,{x=x,y=newy})
			print("STACK INSERT x: "..st[#st].x.." y: "..st[#st].y)
			r,gr,b=   imgdata:getPixel(st[#st].x-1,     st[#st].y-1)
			rh,grh,bh=imgdata:getPixel(st[#st].x-1+dirx,st[#st].y-1)
			rv,grv,bv=imgdata:getPixel(st[#st].x-1,     st[#st].y-1+diry)
			love.graphics.points(x,st[#st].y)
		--if pixel below is not black, then move to pixel to the left and start over
		elseif (rh==0 and grh==0 and bh==0) then
			-- local newx=st[#st].x+dirx
			x=x+dirx
			r,gr,b=imgdata:getPixel(x-1,st[#st].y-1)
			rh,grh,bh=imgdata:getPixel(x-1+dirx,st[#st].y-1)
			rv,grv,bv=imgdata:getPixel(x-1,st[#st].y-1+diry)
			-- love.graphics.points(x,st[#st].y)
		--if surounding pixels are all black, nowheres to go, so move back to last point in stack, pop last point from stack
		else
			-- if (r==0 and gr==0 and b==0) then
			-- 	love.graphics.points(x,y)
			-- end
			-- x,y=st[#st].x,st[#st].y
			print("STACK REMOVE x: "..st[#st].x.." y: "..st[#st].y)
			table.remove(st)
			x=st[#st].x
			-- x=x+dirx
			r,gr,b=   imgdata:getPixel(x-1,     st[#st].y-1)
			rh,grh,bh=imgdata:getPixel(x-1+dirx,st[#st].y-1)
			rv,grv,bv=imgdata:getPixel(x-1,     st[#st].y-1+diry)
			-- love.graphics.points(x,st[#st].y)
			
			-- if (rh~=0 or grh~=0 or bh~=0) and (rv~=0 or grv~=0 or bv~=0) then
			-- 	table.remove(st)
			-- 	x,y=st[#st].x,st[#st].y
			-- 	r,gr,b=imgdata:getPixel(x-1,y-1)
			-- 	rh,grh,bh=imgdata:getPixel(x-1+dirx,y-1)
			-- 	rv,grv,bv=imgdata:getPixel(x-1,y-1+diry)
			-- end
		end
	end
end

roaddrivin.level={}
roaddrivin.level.country = {
	make = function(g,l)
		l.filldraw=false
		l.fillx,l.filly=0,1
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
					l.filldraw=true
				end
			end

			-- if l.filldraw==true then
			-- 	if l.fillx<l.map.width then
			-- 		l.fillx=l.fillx+1
			-- 	elseif l.filly<l.map.height then
			-- 		l.fillx=1
			-- 		l.filly=l.filly+1
			-- 	else
			-- 		l.filldraw=false
			-- 		l.bgdraw=false
			-- 	end
			-- end
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
			local imgdata=l.canvas.background:newImageData()
			if l.bgdraw==true then
				if l.canvas then
					if l.canvas.background then
						LG.setCanvas(l.canvas.background)
						if not l.filldraw then
							LG.setColor(g.palette["red"])
							love.graphics.points(l.destx,l.desty)
						else
							local x,y=l.map.width/2,l.map.height/2
							-- local r,gr,b=imgdata:getPixel(x-1,y-1)
							LG.setColor(g.palette["green"])
							-- love.graphics.points(x,y)
							roaddrivin.fillthing(l,imgdata,x,y,-1,1)

							-- while r==0 and gr==0 and b==0 do
							-- 	love.graphics.points(x,y)
							-- 	local newx=x-1
							-- 	local r2,gr2,b2=imgdata:getPixel(newx,y)
							-- 	while r2==0 and gr2==0 and b2==0 do
							-- 		love.graphics.points(newx,y+1)
							-- 		newx=newx-1
							-- 		r2,gr2,b2=imgdata:getPixel(newx,y)
							-- 	end
							-- 	x=x-1
							-- 	r,gr,b=imgdata:getPixel(x-1,y-1)
							-- 	if r~=0 or gr~=0 or b~=0 then
							-- 		y=y+1
							-- 		x=l.map.width/2
							-- 		r,gr,b=imgdata:getPixel(x-1,y-1)
							-- 	end
							-- end
							
							-- local col="blue"
							-- for y=1,l.map.height do
							-- 	if col~="blue" then col="blue" end
							-- 	local sw={}
							-- 	for i=1,l.map.width-1 do--check the rest of this horizontal line of pixels for another non black pixel
							-- 		local r3,gr3,b3=imgdata:getPixel(i,y-1)
							-- 		if r3==0 and gr3==0 and b3==0 then--if current pixel is black
							-- 			local r4,gr4,b4=imgdata:getPixel(i-1,y-1)
							-- 			if r4~=0 or gr4~=0 or b4~=0 then--if previous pixel is not black
							-- 				table.insert(sw,i)
							-- 			end
							-- 			-- if x<i then
							-- 			-- 	if r3==0 and gr3==0 and b3==0 then
							-- 			-- 		col="green"
							-- 			-- 	end
							-- 			-- else
							-- 			-- 	col="blue"
							-- 			-- end
							-- 		end
							-- 	end
							-- 	for x=1,l.map.width do
							-- 		-- local r,gr,b=imgdata:getPixel(x-1,y-1)
							-- 		-- if r==0 and gr==0 and b==0 then--if current pixel is black
							-- 		-- 	if x>1 then
							-- 		-- 		local r2,gr2,b2=imgdata:getPixel(x-2,y-1)
							-- 		-- 		if r2~=0 or gr2~=0 or b2~=0 then--then if previous pixel is not black, we've crossed a line
							-- 		-- 			if col=="blue" then
							-- 		-- 				-- local sw=false

							-- 		-- 				-- if sw==true then
							-- 		-- 				-- 	col="green"
							-- 		-- 				-- end
							-- 		-- 			end
							-- 		-- 			-- if col=="blue" then
							-- 		-- 			-- 	col="green"
							-- 		-- 			-- else
							-- 		-- 			-- 	col="blue"
							-- 		-- 			-- end
							-- 		-- 		end
							-- 		-- 	end
							-- 		-- 	LG.setColor(g.palette[col])
							-- 		-- 	love.graphics.points(x,y)
							-- 		-- end
							-- 		local intersect,index=supper.contains(sw,x)
							-- 		if intersect==true then
							-- 			if #sw%2==0 and #sw>1 then--if amount of intersections is even
							-- 				if index%2==1 then--then if this interesection
							-- 		 			col="green"
							-- 				else
							-- 					col="blue"
							-- 				end
							-- 			else
							-- 				if index%2==0 then
							-- 		 			col="blue"
							-- 				else
							-- 					col="green"
							-- 				end
							-- 			end
							-- 		end
							-- 		LG.setColor(g.palette[col])
							-- 		love.graphics.points(x,y)
							-- 	end
							-- end
							l.filldraw=false
							l.bgdraw=false
						end
						LG.setColor(g.palette["pure_white"])
					end
				end
				LG.setCanvas(g.canvas.main)
			end
			-- imgdata:mapPixel(pixelmaps.squish)
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