local function make(t,x,y,d,vel,...)
	local a={}
	a.t=t
	a.x=x or love.math.random(319)
	a.y=y or love.math.random(239)
	a.d=d or 0
	a.vel=vel or 0
	a.vec={math.cos(a.d),math.sin(a.d)}
	a.angle=0
	a.speed=1
	a.delta=Game.timer
	a.delete=false
	a.flags = 0x0
	if _G[EA[a.t]]["make"] then
		_G[EA[a.t]]["make"](a,...)
	end
	if flags.get(a.flags,EA.flags.item) then
		item.make(a)
		a.st=EA.flags.item
	elseif flags.get(a.flags,EA.flags.collectible) then
		a.st=EA.flags.collectible
	end
	counters.update(Game.counters,a,1)
--[[
	if flags.get(a.flags,EF.queue) then
		Game.actors[ EA[a.t].."s" ][ EA[a.t].."s" ]={}
	end
--]]
	table.insert(Game.actors,a)
	return a
end

local function control(a,gs)
	controller.update(a,gs)

	if a.menu then
		a.menu.x=a.x
		a.menu.y=a.y
	end

	--actor.calltype(a,gs,debug.getinfo(1,"n").name)

	if a.st then
		if _G[EA.flags[a.st]]["control"] then
			_G[EA.flags[a.st]]["control"](a,gs)
		end
	end

	if _G[EA[a.t]]["control"] then
		_G[EA[a.t]]["control"](a,gs)
	end

	if a.anglespeed then
		if a.anglespeeddecel then
			a.anglespeed=math.snap(a.anglespeed,a.anglespeeddecel,0)
		end
		a.angle = a.angle + a.anglespeed*a.vec[1]*math.pi*2*gs
	end

	if a.hit then
		if a.hit>0 then
			a.hit=a.hit-gs
		else
			a.c=a.cinit--TODO this is probably where weird colour stuff is happenin with snakes
		end
	end

	a.vec[1] = math.cos(a.d)
	a.vec[2] = math.sin(a.d)

	local xcell,ycell=map.getcell(Game.map,a.x,a.y)
	local xdest,ydest=a.x + a.vec[1]*a.vel*a.speed*gs,a.y - a.vec[2]*a.vel*a.speed*gs
	local xcelldest,ycelldest=map.getcell(Game.map,xdest,ydest)
	
	local xmapcell=Game.map[ycell][xcelldest]
	local ymapcell=Game.map[ycelldest][xcell]
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
		if _G[EA[a.t]]["collision"] then
			_G[EA[a.t]]["collision"](a)
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

	if a.decel then
		a.vel=math.snap(a.vel,a.decel*(Game.timer-a.delta)/4,0)
	end

	if flags.get(a.flags,EF.shopitem) then
		if vector.distance(a.x,a.y,Player.x,Player.y)<30 then
			sprites.blink(a,24)
			if Player.controllers.aim.powerup then
				if Player.coin>=a.cost then
					a.flags=flags.switch(a.flags,EF.shopitem)
					actor.corpse(a.menu,a.menu.w+1,a.menu.h+1,true)
					actor.make(EA.explosion,a.x,a.y,0,0,EC.white,40)
					a.menu=nil
					Player.coin=Player.coin-a.cost
				else
					sfx.play(11)
				end
			end
		else
			a.spr=a.sprinit
		end
	end

	if a.inv then
		for i=1,#a.inv do
			item.carry(a.inv[i],a)
		end
	end
	if a.tail then
		local c=a.controllers.aim
		tail.control(a.tail,gs,a,c.aimhorizontal,c.aimvertical)
	end

	if a.x<-10
	or a.x>330
	or a.y>250
	or a.y<-10 then
		if not flags.get(a.flags,EF.persistent) then
			a.delete=true
	 	end
	end
end

local function draw(a)
	if a.menu then
		menu.draw(a.menu)
	end
	if _G[EA[a.t]]["predraw"] then
		_G[EA[a.t]]["predraw"](a)
	end

	local r,g,b=unpack(Game.palette[a.c])
	local alpha=255
	if a.alpha then
		alpha=a.alpha
	end
	LG.setColor(r,g,b,alpha)
	sprites.draw(a)

	if _G[EA[a.t]]["draw"] then
		_G[EA[a.t]]["draw"](a)
	end

	if a.tail then
		tail.draw(a.tail)
	end

	if Debugger.debugging then
		LG.setColor(Game.palette[EC.blue])
		if a.hitradius then
			LG.circle("line",a.x,a.y,a.hitradius.r)
		elseif a.hitbox then
			LG.rectangle("line",a.x+a.hitbox.x,a.y+a.hitbox.y,a.hitbox.w,a.hitbox.h)
		end
		LG.points(a.x,a.y)
		--LG.print(a.flags,a.x+8,a.y-8)
	end

	LG.setColor(Game.palette[EC.pure_white])
end

local function damage(a,d)
	if not a.delete then
		sfx.play(a.hitsfx,a.x,a.y)

		if flags.get(a.flags,EF.damageable) then
			a.hp = a.hp - d
			if _G[EA[a.t]]["damage"] then
				_G[EA[a.t]]["damage"](a)
			end
			for i=1,4 do
				actor.make(EA.debris,a.x,a.y)
			end
			if a.hittime then
				if a.hit<a.hittime then
					a.hit=a.hittime
				end
				a.c=a.hitcolour
			end
			if a.hp<1 then
				--sfx.play(a.deathsnd,a.x,a.y)
				a.delete=true

				if Player.hp>0 then
					if a.value then
						Game.score=Game.score+a.value
						local l=Game.levels.current
						l.spawnindex=math.clamp(l.spawnindex+1,1,#l.enemies,true)
					end
				end

				if flags.get(a.flags,EF.explosive) then
					actor.make(EA.explosion,a.x,a.y,0,0,EC.white,20*(a.size))
				end

				if flags.get(a.flags,EA.flags.character) then
					character.dead(a)
				end
				if _G[EA[a.t]]["dead"] then
					_G[EA[a.t]]["dead"](a)
				end
			end
		end
	end
end

local function impulse(a,dir,vel,glitch)
	glitch=glitch or false
	local vecx=math.cos(a.d)
	local vecy=math.sin(a.d)
	local impx=math.cos(dir)
	local impy=math.sin(dir)

	if glitch then
		impy = -impy
	end

	local outx,outy=vector.normalize(vecx+impx,vecy-impy)
	local outvel=a.vel+vel
	
	return vector.direction(outx,outy), outvel
end

local function collision(x,y,enemy)--TODO something other than enemy here?
	local dist=vector.distance(enemy.x,enemy.y,x,y)
	if enemy.hitradius then
		if dist<enemy.hitradius.r then
			return true
		else
			return false
		end
	elseif enemy.hitbox then
		if x>enemy.x+enemy.hitbox.x then
		if x<enemy.x+enemy.hitbox.x+enemy.hitbox.w then
		if y>enemy.y+enemy.hitbox.y then
		if y<enemy.y+enemy.hitbox.y+enemy.hitbox.h then
			return true
		end
		end
		end
		end
	end
	return false
end

local function corpse(a,tw,th,hack)
	local dir=math.randomfraction(math.pi*2)
	local ix,iy=a.x-tw/2,a.y-th/2
	local ix2,iy2=ix+tw,iy+th

	if ix<0 then ix=0 end
	if iy<0 then iy=0 end
	if ix2>Game.width then
		local diff=ix2-Game.width
		tw=tw-diff
	end
	if iy2>Game.height then
		local diff=iy2-Game.height
		th=th-diff
	end
	
	local body=actor.make(EA.debris,a.x,a.y)
	body.decel=0.1
	if not hack then
		local choice=math.choose(1,2)
		if choice==1 then
			local imgdata=Game.canvas.main:newImageData(ix,iy,tw,th)
			body.image=LG.newImage(imgdata)
		else
			local imgdata=Game.canvas.main:newImageData(ix,iy,tw/2,th)
			body.image=LG.newImage(imgdata)
			body.d=dir

			local body2=actor.make(EA.debris,a.x,a.y)
			body2.decel=0.1
			local imgdata2=Game.canvas.main:newImageData(ix+tw/2,iy,tw/2,th)
			body2.image=LG.newImage(imgdata2)
			body2.d=dir+math.randomfraction(0.5)-0.25
		end
	else
		body.decel=0.2
		local imgdata=Game.canvas.main:newImageData(ix,iy,tw/2,th/2)
		body.image=LG.newImage(imgdata)
		body.d=math.randomfraction(math.pi*2)

		local body2=actor.make(EA.debris,a.x,a.y)
		body2.decel=0.2
		local imgdata2=Game.canvas.main:newImageData(ix+tw/2,iy+th/2,tw/2,th/2)
		body2.image=LG.newImage(imgdata2)
		body2.d=math.randomfraction(math.pi*2)

		local body3=actor.make(EA.debris,a.x,a.y)
		body3.decel=0.2
		local imgdata3=Game.canvas.main:newImageData(ix+tw/2,iy,tw/2,th/2)
		body3.image=LG.newImage(imgdata3)
		body3.d=math.randomfraction(math.pi*2)

		local body4=actor.make(EA.debris,a.x,a.y)
		body4.decel=0.2
		local imgdata4=Game.canvas.main:newImageData(ix,iy,tw/2,th/2)
		body4.image=LG.newImage(imgdata4)
		body4.d=math.randomfraction(math.pi*2)
	end
end

--local function calltype(a,gs,fn)
--	if _G[EA[a.t]][fn] then
--		_G[EA[a.t]][fn](a,gs)
--	end
--end

return
{
	make = make,
	control = control,
	draw = draw,
	collision = collision,
	damage = damage,
	impulse = impulse,
	corpse = corpse,
	--calltype = calltype,
}