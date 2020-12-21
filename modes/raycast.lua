local raycast={}
raycast.actor={}
raycast.player={}
raycast.level={}

raycast.actor.control = function(g,a,m,gs)
	if a.controller then
		local c=a.controller.move
		if c then
			-- a.d=math.clamp(a.d+c.horizontal*0.05,-math.pi,math.pi,true)
			a.d=a.d+c.horizontal*0.05
			a.vel=c.vertical*-0.1
		end
	end
	a.vec[1]=math.cos(a.d)
	a.vec[2]=-math.sin(a.d)
	a.angle=a.d

	-- if a.inventory then
	-- 	if #a.inventory>0 then
	-- 		c=a.controller
	-- 		item.use(g,a.inventory[1],gs,a,c.aim.horizontal,c.aim.vertical,c.action.use)
	-- 	end
	-- end

	local xdest,ydest=a.x+a.vec[1]*a.vel*a.speed*gs,a.y-a.vec[2]*a.vel*a.speed*gs

	local xmapcell=map.getcellraw(m,xdest,a.y)
	local ymapcell=map.getcellraw(m,a.x,ydest)
	local collx,colly=false,false
	if not flags.get(xmapcell,EF.solid,16) then
		a.x=xdest
	else
		collx=true
	end
	if not flags.get(ymapcell,EF.solid,16) then
		a.y=ydest
	else
		colly=true
	end

	if collx or colly then
		run(EA[a.t],"collision",g,a)
		if a.collisions then
			collisions.run(g,a)
		end

		if flags.get(a.flags,EF.bouncy) then
			if collx then
				a.vec[1]=-a.vec[1]
				a.d=vector.direction(a.vec[1],a.vec[2])
			end
			if colly then
				a.vec[2]=-a.vec[2]
				a.d=vector.direction(a.vec[1],a.vec[2])
			end
		end
	end
end

raycast.actor.draw = function(g,a)
	local a=g.player
	local mult=1/30
	for i=#a.rays,1,-1 do--TODO why?
		local v=a.rays[i]
		local columnwidth=g.width/#a.rays
		-- if math.ceil(v.len)<=30 then
		-- 	if #Enemies[math.ceil(v.len)]>0 then
		-- 		local index=Enemies[math.ceil(v.len)][1]
		-- 		actor.draw(index)
		-- 	end
		-- end
		--love.graphics.setColor(255,255,255,255-v.len*8)
		-- love.graphics.setColor(255-v.len*8,255-v.len*8,255-v.len*8,255)
		love.graphics.setColor(1-v.len*mult,1-v.len*mult,1-v.len*mult,1)
		-- love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle("fill",(v.x-1)*columnwidth,(g.height/2)-(200/v.len),columnwidth,400/v.len)
		love.graphics.setColor(g.palette["pure_white"])
	end

	love.graphics.setColor(1,1,1,0.1)
	actor.twodimensional.draw(g,a)

	-- love.graphics.line(a.x,a.y,a.x+a.vec[1]*10,a.y+a.vec[2]*10)
	for i=#a.rays,1,-1 do
		love.graphics.setColor(1,i*0.05,1)
		local vecx=math.cos(a.rays[i].d)
		local vecy=math.sin(a.rays[i].d)
		local len=a.rays[i].len
		love.graphics.line(a.x,a.y,a.x+vecx*len,a.y+vecy*len)
	end
	love.graphics.setColor(g.palette["pure_white"])

	-- if a.spr then
	-- 	local p=g.player
	-- 	if p then
	-- 	local dir=vector.direction(vector.components(p.x,p.y,a.x,a.y))
	-- 	local dist=vector.distance(p.x,p.y,a.x,a.y)
	-- 	local ray=raycast.castray(g,p.x,p.y,dir,dist,0.1)
	-- 	--if ray.len>=dist*math.cos(dir-Player.d) then
	-- 		local anim=0
	-- 		if a.anim then
	-- 			anim=math.floor((Timer/a.anim.speed)%a.anim.frames)
	-- 		end
	-- 		--love.graphics.setColor(255,0,77,255-dist*8)
	-- 		--love.graphics.setColor(255,0,77,0+dist*8)--ghosties oouuuououuou
	-- 		love.graphics.setColor(255-dist*8,0,77-dist*8,255)
	-- 		-- local deltadir=dir-(p.d-g.camera.fov/2)
	-- 		local deltadir=dir-(p.d-1/2)
	-- 		local x=(deltadir)*g.width
	-- 		local s=Sprites[1]
	-- 		local m=g.level.map
	-- 		love.graphics.draw(s.spritesheet,s.quads[1],x,(g.height/2)+(100/dist),a.d,25/dist,25/dist,(a.size*m.tile.width)/2,(a.size*m.tile.height)/2)
	-- 	--end
	-- 	end
	-- end
end

raycast.player.control = function(g,a)
	a.rays={}
	local x=1
	for i=-1/2,1/2,0.01 do
		local r=raycast.castray(g,a.x,a.y,a.d+i,30,0.1)
		r.len=r.len*math.cos(i)
		r.x=x
		x=x+1
		table.insert(a.rays,r)
	end
	local function raysort(a,b)
		if a.len<b.len then
			return true
		else
			return false
		end
	end
	table.sort(a.rays,raysort)
end

raycast.level.make = function(g,l)
	print("INPUT AIM")
	l.settings={inputaim=true, inputretical=true}
	print(l.settings.inputaim)
end

--TODO consolidate with ray.cast stuff
raycast.castray = function(g,x,y,d,dist,step)
	local ray={}
	ray.d=d
	for j=step,dist,step do
		-- local cellx=math.floor(x+math.cos(d)*j)
		-- local celly=math.floor(y+math.sin(d)*j)
		local m=g.level.map
		local cellx,celly=map.getcellcoords(m,x+math.cos(d)*j,y+math.sin(d)*j)
		-- local cell=Map[celly][cellx]
		local cell=map.getcellraw(m,cellx,celly,true)
		if cell then
			-- if cell==1 then
			if map.solid(cell) then
				local xlast=x+math.cos(d)*(j-step)
				local ylast=y+math.sin(d)*(j-step)
				local ray2=raycast.castray(g,xlast,ylast,d,step,step/10)
				ray.len=j+ray2.len
				return ray
			end
		end
	end
	ray.len=dist
	return ray
end

return raycast