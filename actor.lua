local actor={}
actor.twodimensional={}

--TODO this is unused right now, but may be used if WE decide to use genereic templates for actors rather than assigning them all their own values
actor.load = function(g,name,x,y,d,angle,vel,c)
	local a={}
	supper.copy(a,g.actordata[name])

	a.name=name
	a.x=x or love.math.random(319)
	a.y=y or love.math.random(239)
	a.d=d or 0
	a.angle=angle or 0
	a.vel=vel or 0
	a.c=c or 1
	a.cinit=a.c
	a.vec={math.cos(a.d),math.sin(a.d)}
	a.speed=1
	a.delta=g.timer
	a.delete=false
	a.flags=0x0
	if g.actordata[name].flags then
		a.flags=flags.set(a.flags,g.actordata[name].flags)
	end

	g.actordata[name].count=g.actordata[name].count+1

	table.insert(g.actors,a)
	return a
end

actor.make = function(g,t,x,y,d,vel,...)
	local a={}
	a.t=t
	a.x=x or love.math.random(319)
	a.y=y or love.math.random(239)
	a.d=d or 0
	a.vel=vel or 0
	a.vec={math.cos(a.d),math.sin(a.d)}
	a.angle=0
	a.speed=1
	a.delta=g.timer
	a.delete=false
	a.flags = 0x0
	game.state.run(g.name,"actor","make",g,a,...)
	game.counters(g,a,1)

	--TODO in here do if inivalues.flags then flags.set(a,EF[flagname],...)

	table.insert(g.actors,a)

	game.state.run(g.level.modename,"actor","make",g,a)

	return a
end

--TODO make this way less game-specific, take out everthing but abstract stuff for the most part
actor.control = function(g,a,gs)
	controller.update(a,gs)

	if flags.get(a.flags,EF.player) then
		game.player.control(g,a)
	end
	
	if g.level then
		if g.level.mode then
			game.state.run(g.level.modename,"actor","control",g,a,g.level.map,gs)
		end
	end
	game.state.run(g.name,"actor","control",g,a,gs)--TODO is it okay that this is here now, instead of farther down?

	if a.controls then
		controls.run(g,a,gs)
	end

	if a.item then--if a IS an item, do its item stuff
		item.control(g,a,gs)
	end

	if a.collectible then--if a IS a collectible, do its collectible stuff
		collectible.control(g,a,gs)
	end

	--just do a.drawcalc or something better sounding here, animation calcs etc
	if a.anglespeed then--TODO make angle module with speed and accel
		if a.anglespeeddecel then
			a.anglespeed=math.snap(a.anglespeed,a.anglespeeddecel,0)
		end
		a.angle = a.angle + a.anglespeed*a.vec[1]*math.pi*2*gs
	end

	if a.hit then
		hit.control(a.hit,a,gs)
	end

	if a.flash then
		flash.control(g,a,a.flash)
	end


	local decel=a.decel
--[[
	if g.actordata[EA[a.t] ] then
		decel=g.actordata[EA[a.t] ].decel
	end
--]]
	if decel then--TODO make decel module with speed OR velocity module? w speed and accel
		a.vel=math.snap(a.vel,decel*(g.timer-a.delta)/4*gs,0)
		--a.vel=math.snap(a.vel,a.decel*gs,0)
--[[
		if not a.transition then
			module.make(g,a,EM.transition,easing.linear,"vel",a.vel,-a.vel,30)
		else
			transition.control(g,a,a.transition)
		end
--]]
	end

	if a.transition then
		transition.control(g,a,a.transition)
	end

	if flags.get(a.flags,EF.shopitem) then
		--TODO this only works for single player right now
		game.state.run(g.name,"shopitem","control",g,a,g.player)
	end

	if a.inventory then
		inventory.control(g,a,a.inventory)
	end

--[[
	if a.item then
		game.state.run(g.name,"item","control",g,a)
	end
--]]

	-- game.state.run(g.name,"actor","control",g,a,gs)--this is moved up farther now, is that okay?

	local m=g.level.map
	if a.x<-10
	or a.x>m.width+10
	or a.y>m.height+10
	or a.y<-10 then
		if not flags.get(a.flags,EF.persistent) then
			a.delete=true
	 	end
	end
end

actor.draw = function(g,a)
	if a.menu then
		menu.draw(g,a.menu)
	end

	if g.level then
		if g.level.mode then
			game.state.run(g.level.modename,"actor","draw",g,a)
		end
	end

	-- game.state.run(g.name,"actor","draw",g,a)

	if flags.get(a.flags,EF.player) then
		game.player.draw(g,a)
	end
end

actor.damage = function(g,a,d)
	if not a.delete then
		if a.sound then
			if a.sound.damage then
				sfx.play(g,a.sound.damage,a.x,a.y)
			end
		end

		--TODO a lot of this stuff is game specific, or rather level specific (each level should have its own rules/"physics" and some games just have the same for every level, whereas games with different modes in different parts of the game will have different rules/physics in different levels)
		if flags.get(a.flags,EF.damageable) then
			a.hp=a.hp-d
			-- run(EA[a.t],"damage",a)--TODO should game.state.run(g.name,"actor","damage",g,a,d) be here instead?
			if flags.get(a.flags,EF.player) then
				game.player.damage(g,a)
			end

			game.state.run(g.name,"actor","damage",g,a,d)

			if a.hit then
				hit.damage(a.hit,a)
			end

			if a.hp<1 then
				--sfx.play(g,a.deathsnd,a.x,a.y)
				a.delete=true

				game.state.run(g.name,"actor","dead",g,a)
				if flags.get(a.flags,EF.player) then
					game.player.dead(g,a)
				end
				
				-- run(EA[a.t],"dead",g,a)--TODO is it okay that game.state.run(g.name,"actor","dead",g,a) is not down here?
			end
		end
	end
end

-- actor.impulse = function(a,dir,vel,glitch)
-- 	glitch=glitch or false
-- 	local vecx=math.cos(a.d)
-- 	local vecy=math.sin(a.d)
-- 	local impx=math.cos(dir)
-- 	local impy=math.sin(dir)

-- 	if glitch then
-- 		impy = -impy
-- 	end

-- 	local outx,outy=vector.normalize(vecx+impx,vecy-impy)
-- 	local outvel=a.vel+vel
	
-- 	return vector.direction(outx,outy), outvel
-- end

actor.collision = function(x,y,enemy)--TODO something other than enemy here?
	local dist=vector.distance(enemy.x,enemy.y,x,y)
	if enemy.hitradius then
		return hitradius.collision(enemy.hitradius.r,dist)
	elseif enemy.hitbox then
		return hitbox.collision(x,y,enemy)
	end
	return false
end

actor.twodimensional.draw = function(g,a)
--[[
	run(EA[a.t],"predraw",a)
--]]

	local c=a.c or "pure_white"
	--local c=a.c or g.actordata[EA[a.t]].c
	local r,gr,b=unpack(g.palette[c])
	local alpha=1
	if a.alpha then
		alpha=a.alpha
	end
	LG.setColor(r,gr,b,alpha)--TODO COL
	-- love.graphics.setShader(Shader)
	sprites.draw(g,a)
	-- love.graphics.setShader()

--[[
	if a.char then
		LG.print(a.char,a.x,a.y)
	end
--]]

	--actordata
	--if a.t then
		-- run(a.t,"draw",g,a)--actor's specific draw function (ie snake.draw)
		game.state.run(g.name,"actor","draw",g,a)
	--end

	if Debugger.debugging then
		LG.setColor(g.palette["blue"])
		if a.hitradius then
			hitradius.draw(a)
		elseif a.hitbox then
			hitbox.draw(a)
		end
		LG.points(a.x,a.y)
		if a.deltimer then
			LG.print(a.deltimer,a.x,a.y)
		end
		--LG.print(a.flags,a.x+8,a.y-8)
	end

	LG.setColor(g.palette["pure_white"])
end

return actor