local topdown={}
topdown.actor={}
topdown.level={}

topdown.actor.control = function(g,a,m,gs)
	if a.controller then
		local c=a.controller.move
		if c then
			a.d=vector.direction(c.horizontal,-c.vertical)
			a.vel=vector.length(c.horizontal,c.vertical)
		end
	end
	a.vec={vector.vectors(a.d)}

	if a.inventory then
		if #a.inventory>0 then
			c=a.controller
			item.use(g,a.inventory[1],gs,a,c.aim.horizontal,c.aim.vertical,c.action.use)
		end
	end

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
		a.y = ydest
	else
		colly=true
	end

	if collx or colly then
		-- run(EA[a.t],"collision",g,a)
		game.state.run(g.name,"actor","collision",g,a)
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

topdown.actor.draw = function(g,a)
	actor.twodimensional.draw(g,a)
end

topdown.level.make = function(g,l)
	print("INPUT AIM")
	l.settings={inputaim=true, inputretical=true}
	print(l.settings.inputaim)
end

return topdown