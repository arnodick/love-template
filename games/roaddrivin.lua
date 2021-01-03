local roaddrivin={}

roaddrivin.make = function(g)

end

roaddrivin.level={}

roaddrivin.level.country={}
roaddrivin.level.country.make = function(g,l)
	-- l.filldraw=false
	l.fillx,l.filly=0,1
	local centrex,centrey=g.width/2,g.height/2
	local amount=love.math.random(12,20)
	local dirs={}
	for i=1,amount do
		table.insert(dirs,math.randomfraction(math.pi*2))
	end
	table.sort(dirs)
	l.p={}
	for i,v in ipairs(dirs) do
		local dist=love.math.random(20,100)
		local vx,vy=vector.vectors(v)
		table.insert(l.p,{x=math.round(centrex+vx*dist),y=math.round(centrey+vy*dist)})
	end
	table.insert(l.p,l.p[1])

	l.i=1
	l.linedraw=true
	l.line={0,0,0,0}
	l.pixelx,l.pixely=l.p[l.i].x,l.p[l.i].y
	l.imgdata=l.canvas.background:newImageData()

	l.coroutines=supper.coroutines.make(
		coroutine.create(function()
			for i,v in ipairs(l.p) do
				l.line={centrex,centrey,v.x,v.y}
				coroutine.yield()
			end
			l.linedraw=false
			-- coroutine.resume(l.co)
		end),
		coroutine.create(function()
			while l.bgdraw==true do
				local destx,desty=l.p[l.i+1].x,l.p[l.i+1].y
				local dir=vector.direction(l.pixelx,l.pixely,destx,desty)
				local rand=math.randomfraction(math.pi/2)
				rand=rand*math.choose(-1,1)
				local vecx,vecy=vector.vectors(dir+rand)
				l.pixelx,l.pixely=l.pixelx+vecx,l.pixely+vecy
				
				if math.round(l.pixelx)==destx and math.round(l.pixely)==desty then
					if l.i<#l.p-1 then
						l.i=l.i+1
					else
						print("OK")
						l.bgdraw=false
						-- coroutine.resume(l.co2)
						--TODO do l.filldarw==true stuff in here
					end
				end
				coroutine.yield()
			end
		end),
		coroutine.create(function()
			print("co2")
		end)
	)
end
roaddrivin.level.country.control = function(g,l)
	local running=supper.coroutines.control(l.coroutines)
	if not running then
		level.make(g,1,Enums.modes.topdown)
	end
end
roaddrivin.level.country.draw = function(g,l)
	if l then
		if l.bgdraw==true then
			if l.canvas then
				if l.canvas.background then
					LG.setCanvas(l.canvas.background)
						if l.linedraw==true then
							LG.line(unpack(l.line))
							-- l.imgadata:setPixel()
						else
							local red=g.palette["red"]
							l.imgdata:setPixel(l.pixelx-1,l.pixely-1,red[1],red[2],red[3])
						end
					LG.setColor(g.palette["pure_white"])
				end
			end
			--TODO draw only first frame with all red pixels to the buffer. which won't change, so we can use it for colour ref on actual bg, which wil be changing from pixelmap
			--then can say in pxelmap, if col==red do this pixelmap, but if green do this
				--TODO need approximately value to convert between pixelmap colour value and lua. .3 == >0.29 and < 0.31?
			LG.setCanvas(g.canvas.main)
		end

		--TODO do shaderinstead of this stuff so no memory leaks
		-- l.imgdata:mapPixel(pixelmaps.squish)
		-- l.imgdata:mapPixel(pixelmaps.sparkle)
		-- l.imgdata:mapPixel(pixelmaps.melt)
		l.imgdata:mapPixel(pixelmaps.unred)
		local image=LG.newImage(l.imgdata)
		LG.setCanvas(l.canvas.background)
			love.graphics.draw(image,0,0,0,1,1)
		LG.setCanvas(g.canvas.main)
		image:release()
	end
end

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

roaddrivin.gameplay={}
roaddrivin.gameplay.make = function(g)
	--TODO just do this, take map generators, args, drawmodes out of level json file
	--map.generate(g.map,"country",{arguyments here})
	level.make(g,1,Enums.modes.topdown)
	-- local m=g.level.map
	-- actor.make(g,EA.roaddrivin_actor,m.width/2-5,m.height/2-5)
end
roaddrivin.gameplay.keypressed = function(g,key)
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
end
roaddrivin.gameplay.draw = function(g)
end

roaddrivin.title={}
roaddrivin.title.keypressed = function(g,key)
	if game.keyconfirm(key) then
		game.state.make(g,"gameplay")
	elseif key=='escape' then
		game.state.make(g,"intro")
	end
end
roaddrivin.title.gamepadpressed = function(g,joystick,button)
	if button=="start" or button=="a" then
		game.state.make(g,"gameplay")
	end
	if button=="b" then
		game.state.make(g,"intro")
	end
end
roaddrivin.title.draw = function(g)
	LG.print("TITLE", g.width/2, g.height/2)
end

roaddrivin.intro={}
roaddrivin.intro.keypressed = function(g,key)
	if game.keyconfirm(key) then
		game.state.make(g,"title")
	end
end
roaddrivin.intro.gamepadpressed = function(g,joystick,button)
	if button=="start" or button=="a" then
		game.state.make(g,"title")
	end
end
roaddrivin.intro.draw = function(g)
	LG.print("INTRO", g.width/2, g.height/2)
end

roaddrivin.option={}
roaddrivin.option.keypressed = function(g,key)
	if key=='escape' then
		game.state.make(g,"title")
	end
end
roaddrivin.option.gamepadpressed = function(g,joystick,button)
	if button=="b" then
		game.state.make(g,"intro")
	end
end
roaddrivin.option.draw = function(g)
	LG.print("OPTION",g.width/2,g.height/2)
end

return roaddrivin