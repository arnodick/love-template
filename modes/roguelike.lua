local roguelike={}
roguelike.actor={}
roguelike.level={}

roguelike.actor.drawcoords = function(g,a)
	local m=g.level.map
	local tw,th=m.tile.width,m.tile.height
	local twh,thh=tw/2,th/2
	a.draw={}
	a.draw.x=(a.x-1)*tw+twh
	a.draw.y=(a.y-1)*th+thh
	a.draw.xoff=twh-1
	a.draw.yoff=thh
end

roguelike.actor.make = function(g,a)
	local l=g.level
	map.setcellraw(l.map.actors,a.x,a.y,a)
	roguelike.actor.drawcoords(g,a)
end

--TODO input g here, but not at the end
roguelike.actor.control = function(g,a,m,gs)
	if g.step==true then
		if a.controller then
			local c=a.controller.move
			if c then
				if c.input==EMCI.gamepad then
					local vh=c.horizontal
					local vv=c.vertical
					if vh~=0 then
						a.vec[1]=vh/math.abs(vh)
					else
						a.vec[1]=0
					end
					if vv~=0 then
						a.vec[2]=vv/math.abs(vv)
					else
						a.vec[2]=0
					end
				else
					a.vec[1]=c.horizontal
					a.vec[2]=c.vertical
				end
			end
		end
	
		if flags.get(a.flags,EF.player) then
			print("PLAYER VEC x "..a.vec[1])
			print("PLAYER VEC y "..a.vec[2])
		end
		local xstart,ystart=a.x,a.y
		local xdest,ydest=a.x+a.vec[1],a.y+a.vec[2]

		local ibx=map.inbounds(m,xdest,a.y)
		local iby=map.inbounds(m,a.x,ydest)
		-- print(ibx)
		-- print(iby)
		-- local m=g.level.map.actors
		if ibx and iby then
			-- local collx,colly=map.solid(m,xdest,a.y),map.solid(m,a.x,ydest)
			local collx,colly=map.solid(ibx),map.solid(iby)
			local xdestfinal,ydestfinal=a.x,a.y
			if not collx then
				xdestfinal=xdest
			end
			if not colly then
				ydestfinal=ydest
			end

			-- print("\nACTOR: "..tostring(a))
			if collx or colly then
				-- if collx then
				-- 	print(" WALL COLLISION WITH: "..ibx.." X: "..xdest.." Y: "..a.y)
				-- else
				-- 	print(" WALL COLLISION WITH: "..iby.." X: "..a.x.." Y: "..ydest)
				-- end
				-- run(EA[a.t],"collision",a)
			else
				local ma=g.level.map.actors
				if map.getcellraw(ma,xdestfinal,ydestfinal,true)==0 then
					a.x,a.y=xdestfinal,ydestfinal
					map.setcellraw(ma,xstart,ystart,0)
					
					-- print("MAP START X: "..xstart.." Y: "..ystart)
					map.setcellraw(ma,a.x,a.y,a)
					-- print("MAP DEST X: "..a.x.." Y: "..a.y)
				else
					local ac=map.getcellraw(ma,xdestfinal,ydestfinal,true)
					print("ACTOR COLLISION WITH "..tostring(ac))
					game.state.run(g.name,"actor","collision",g,a,ac)
				end
			end
		else
			print(tostring(a).." OUT OF BOUNDS")
			if a.vec[1]~=0 then
				game.state.run(g.name,"level","outofbounds",g,a,true)
				print(" horiz")
			else
				game.state.run(g.name,"level","outofbounds",g,a,false)
				print(" vert")
			end
		end
		-- supper.print(m)
		roguelike.actor.drawcoords(g,a)
	end
end

roguelike.actor.draw = function(g,a)
	if a.char then
		LG.setColor(a.colour)
		-- LG.print(a.char,a.draw.x,a.draw.y,g.timer/20,1,1,a.draw.xoff,a.draw.yoff)
		LG.print(a.char,a.draw.x,a.draw.y,0,1,1,a.draw.xoff,a.draw.yoff)
		LG.setColor(g.palette["pure_white"])
	end
end

roguelike.level.make = function(g,l)
	l.settings={inputtype="digital"}
	print("RL SETTINGS")
	print(l.settings.inputtype)
	-- TODO put this in roguelike? need to add mode.level.make to level.make?
	if l.map then
		-- print("MAKING ACTORS MAP")
		l.map.actors={}
		map.init(l.map.actors,l.map.w,l.map.h)
		map.generate(l.map.actors,"empty")
		-- if g.player then
		-- 	print("PLAYER INIT")
		-- 	-- map.setcellraw(l.map.actors,g.player.x,g.player.y,g.player)
		-- end
		-- supper.print(l.map.actors)
	end
end

return roguelike