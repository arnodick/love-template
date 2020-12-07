local topdown_tank={}
topdown_tank.actor={}
topdown_tank.level={}

topdown_tank.actor.control = function(g,a,m,gs)
	if a.controller then
		local c=a.controller.move
		if c then
			if c.horizontal~=0 or c.vertical~=0 then
				-- if not a.transition then
				-- 	local controllerdirection=vector.direction(c.horizontal,-c.vertical)
				-- 	local controllerdifference=controllerdirection-a.d
				-- 	--local controllerdifference2=a.d-controllerdirection
				-- 	local controllerdifference2=-a.d-(math.pi*2-controllerdirection)
				-- 	if math.abs(controllerdifference)>math.abs(controllerdifference2) then
				-- 		controllerdifference=controllerdifference2
				-- 	end
				-- 	module.make(g,a,EM.transition,easing.linear,"d",a.d,controllerdifference,math.abs(controllerdifference*10))
				-- end

				a.d=vector.direction(c.horizontal,-c.vertical)
				a.vel=vector.length(c.horizontal,c.vertical)
			else
				a.vel=0
			end
		end
	end
	a.vec[1] = math.cos(a.d)
	a.vec[2] = math.sin(a.d)

	if a.inventory then
		if #a.inventory>0 then
			c=a.controller
			if c then
				item.use(g,a.inventory[1],gs,a,math.cos(a.angle),math.sin(a.angle),c.action.use)--this makes wand point player's direction
				--item.use(g,a.inventory[1],gs,a,c.aim.horizontal,c.aim.vertical,c.action.use)--this make wand point in its own independent direction
			end
		end
	end

	local xcell,ycell=map.getcellcoords(m,a.x,a.y)
	local xdest,ydest=a.x+a.vec[1]*a.vel*a.speed*gs,a.y-a.vec[2]*a.vel*a.speed*gs
	local xcelldest,ycelldest=map.getcellcoords(m,xdest,ydest)
	
	local xmapcell=map.getcellraw(m,xdest,a.y)
	local ymapcell=map.getcellraw(m,a.x,ydest)
	local collx,colly=false,false
	if not flags.get(xmapcell,EF.solid,16) then
		a.x = xdest
	else
		collx=true
	end
	if not flags.get(ymapcell,EF.solid,16) then
		a.y = ydest
	else
		colly=true
	end

	if collx or colly then
		if collx then
			run(EA[a.t],"collision",a,xcelldest,ycell)
		elseif colly then
			run(EA[a.t],"collision",a,xcell,ycelldest)
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

topdown_tank.actor.draw = function(g,a)
	actor.twodimensional.draw(g,a)
end

topdown_tank.level.make = function(g,l)
	print("INPUT AIM")
	l.settings={inputaim=true}
	print(l.settings.inputaim)
end

return topdown_tank