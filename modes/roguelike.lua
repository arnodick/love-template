local roguelike={}
roguelike.actor={}
roguelike.level={}

roguelike.actor.make = function(g,a)
	local l=g.level
	map.setindex(l.map.actors,a.x,a.y,a)
end

--TODO input g here, but not at the end
roguelike.actor.control = function(a,m,gs,g)
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
			print("PLAYER VEC1 "..a.vec[1])
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

			if collx or colly then
				print("\nWALL COLLISION: "..tostring(a))
				run(EA[a.t],"collision",a)
			else
				local m=g.level.map.actors
				if map.getcellraw(m,xdestfinal,ydestfinal,true)==0 then
					a.x,a.y=xdestfinal,ydestfinal
					map.setindex(m,xstart,ystart,0)
					print("\nMAP START X: "..xstart.." Y: "..ystart..": "..tostring(map.getcellraw(m,xstart,ystart,true)))
					map.setindex(m,a.x,a.y,a)
					print("MAP DEST X: "..a.x.." Y: "..a.y..": "..tostring(map.getcellraw(m,a.x,a.y,true)))
				else
					print("\nACTOR COLLISION: "..tostring(a).." WITH "..tostring(map.getcellraw(m,xdestfinal,ydestfinal,true)))
				end
			end
		end
		-- supper.print(m)
	end
end

roguelike.actor.draw = function(g,a)
	if a.char then
		local m=g.level.map
		LG.setColor(100,200,100)--TODO
		LG.print(a.char,(a.x-1)*m.tile.width,(a.y-1)*m.tile.height)
	end
end

roguelike.level.make = function(g,l)
	l.settings={inputtype="digital"}
	print("RL SETTINGS")
	print(l.settings.inputtype)
	-- TODO put this in roguelike? need to add mode.level.make to level.make?
	if l.map then
		l.map.actors={}
		map.init(l.map.actors,l.map.w,l.map.h)
		map.generate(l.map.actors,"empty")
		supper.print(l.map.actors)
	end
end

return roguelike