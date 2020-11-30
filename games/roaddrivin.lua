local roaddrivin={}

roaddrivin.make = function(g)

end

roaddrivin.getpixels = function(imgdata,x,y,dirx,diry)
	local x,y=x-1,y-1
	local r,gr,b=imgdata:getPixel(x,y)
	local rh,grh,bh=imgdata:getPixel(x+dirx,y)
	local rv,grv,bv=imgdata:getPixel(x,y+diry)
	return r,gr,b,rh,grh,bh,rv,grv,bv
end

-- roaddrivin.fillthing = function(l,imgdata,x,y,dirx,diry)
-- 	love.graphics.floodfill(imgdata,x,y)
-- end

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
			if l.bgdraw==true then
				if l.canvas then
					if l.canvas.background then
						local imgdata=l.canvas.background:newImageData()
						LG.setCanvas(l.canvas.background)
						if not l.filldraw then
							LG.setColor(g.palette["red"])
							love.graphics.points(l.destx,l.desty)
						else
							-- local x,y=l.map.width/2,l.map.height/2
							local red=g.palette["red"]
							local blue=g.palette["blue"]
							for y=1,l.map.height do
								for x=1,l.map.width do
									LG.setColor(blue)
									local r,gr,b=imgdata:getPixel(x-1,y-1)
									if love.graphics.coloursame({r,gr,b},{0,0,0}) then
										local crosses=0
										local distances={x,l.map.width-x,y,l.map.height-y}
										table.sort(distances)
										local start=distances[#distances]

										local le,re,u,d=true,true,true,true
										for i=start,1,-1 do
											if le then
												if x-i>0 and x-i<=l.map.width and y>0 and y<=l.map.height then
													local lr=imgdata:getPixel(x-i-1,y-1)
													if lr==1 then
														crosses=crosses+1
														le=false
													end
												end
											end
											if re then
												if x+i>0 and x+i<=l.map.width and y>0 and y<=l.map.height then
													local rr=imgdata:getPixel(x+i-1,y-1)
													if rr==1 then
														crosses=crosses+1
														re=false
													end
												end
											end
											if u then
												if x>0 and x<=l.map.width and y-i>0 and y-i<=l.map.height then
													local ur=imgdata:getPixel(x-1,y-i-1)
													if ur==1 then
														crosses=crosses+1
														u=false
													end
												end
											end
											if d then
												if x>0 and x<=l.map.width and y+i>0 and y+i<=l.map.height then
													local dr=imgdata:getPixel(x-1,y+i-1)
													if dr==1 then
														crosses=crosses+1
														d=false
													end
												end
											end
											if crosses==4 then
												LG.setColor(g.palette["green"])
												-- break
											end
										end
										LG.points(x,y)
									end
								end
							end

							-- love.graphics.floodfill(imgdata,x,y)
							-- love.graphics.points(x,y)
							-- roaddrivin.fillthing(l,imgdata,x,y,-1,1)

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
			-- local image=LG.newImage(imgdata)
			-- LG.setCanvas(l.canvas.background)
			-- 	love.graphics.draw(image,0,0,0,1,1,0,0,0,0)
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