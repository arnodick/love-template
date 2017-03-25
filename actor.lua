local function make(t,st,x,y,d,vel,...)
	--if not (t==EA.effect and #Game.actors>3000) then --TODO figure out how to do this without checking the existence of each returned actor
	local a={}
	a.t=t
	a.st=st
	a.x=x or love.math.random(320)
	a.y=y or love.math.random(240)
	a.d=d or 0
	a.vel=vel or 0
	a.vec={math.cos(a.d),math.sin(a.d)}
	a.angle=0
	a.delta=Game.timer
	a.delete=false
	a.flags = 0x0
	if _G[EA[a.t]]["make"] then
		_G[EA[a.t]]["make"](a,...)
	end
	counters.update(Game.counters,a,1)
	table.insert(Game.actors,a)
	return a
	--end
end

local function control(a,gs)
	controller.update(a,gs)

	--actor.calltype(a,gs,debug.getinfo(1,"n").name)

	if _G[EA[a.t]]["control"] then
		_G[EA[a.t]]["control"](a,gs)
	end

	if a.anglespeed then
		if a.anglespeeddecel then --TODO make this into a function
			if a.anglespeed>0 then
				if a.anglespeed<a.anglespeeddecel then
					a.anglespeed = 0
					a.anglespeeddecel = 0
				else
					a.anglespeed = a.anglespeed - a.anglespeeddecel
				end
			elseif a.anglespeed<0 then
				if a.anglespeed>-a.anglespeeddecel then
					a.anglespeed = 0
					a.anglespeeddecel = 0
				else
					a.anglespeed = a.anglespeed + a.anglespeeddecel
				end
			end
		end
		a.angle = a.angle + a.anglespeed*a.vec[1]*math.pi*2*gs
	end

	if a.hit then
		if a.hit>0 then
			a.hit=a.hit-gs
		else
			a.c=a.cinit
		end
	end

	a.vec[1] = math.cos(a.d)
	a.vec[2] = math.sin(a.d)
	--a.x = a.x + a.vec[1]*a.vel*gs
	--a.y = a.y - a.vec[2]*a.vel*gs
---[[
	
	--local xcell,ycell=math.floor(a.x/tw),math.floor(a.y/th)
	--local xcelldest,ycelldest=math.floor(xdest/tw),math.floor(ydest/th)
	local xcell,ycell=map.getcell(Game.map,a.x,a.y)
	local xdest,ydest=a.x + a.vec[1]*a.vel*gs,a.y - a.vec[2]*a.vel*gs
	local xcelldest,ycelldest=map.getcell(Game.map,xdest,ydest)
	
	local xmapcell=Game.map[ycell][xcelldest]
	local ymapcell=Game.map[ycelldest][xcell]
	local collx,colly=false,false
	if not flags.get(xmapcell,Enums.flags.solid,16) then
		a.x = xdest
	else
		collx=true
	end
	if not flags.get(ymapcell,Enums.flags.solid,16) then
		a.y = ydest
	else
		colly=true
	end
--]]
	if collx or colly then
		if _G[EA[a.t]]["collision"] then
			_G[EA[a.t]]["collision"](a)
		end
		if flags.get(a.flags,Enums.flags.bouncy) then
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
		if a.vel>0 then
			--TODO make decelinit and set decel to it here, so forever moving coins doesn't happen
			if a.vel<=a.decel*(Game.timer-a.delta)/4 then
				a.vel = 0
				a.decel = 0
			else
				a.vel = a.vel - a.decel*gs*(Game.timer-a.delta)/4
			end
		elseif a.vel<0 then
			if a.vel>=-a.decel*(Game.timer-a.delta)/4 then
				a.vel = 0
				a.decel = 0
			else
				a.vel = a.vel + a.decel*gs*(Game.timer-a.delta)/4
			end
		end
	end

	if flags.get(a.flags,Enums.flags.shopitem) then
		if vector.distance(a.x,a.y,Player.x,Player.y)<30 then
			sprites.blink(a,24)
			if Player.controller.powerup then
				if Player.coin>=a.cost then
					a.flags=flags.set(a.flags,Enums.flags.shopitem)
					actor.corpse(a.menu,a.menu.w+1,a.menu.h+1,true)
					actor.make(EA.effect,EA.effects.explosion,a.x,a.y,0,0,EC.white,40)
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
		local c=a.controller
		tail.control(a.tail,gs,a,c.aimhorizontal,c.aimvertical)
	end

	if a.x<-10
	or a.x>330
	or a.y>250
	or a.y<-10 then
		if not flags.get(a.flags,Enums.flags.persistent) then
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

	LG.setColor(Palette[a.c])
	sprites.draw(a)

	if _G[EA[a.t]]["draw"] then
		_G[EA[a.t]]["draw"](a)
	end

	if a.tail then
		tail.draw(a.tail)
	end

	if Debugger.debugging then
		LG.setColor(Palette[EC.blue])
		if a.hitradius then
			LG.circle("line",a.x,a.y,a.hitradius.r)
		elseif a.hitbox then
			LG.rectangle("line",a.x+a.hitbox.x,a.y+a.hitbox.y,a.hitbox.w,a.hitbox.h)
		end
		LG.points(a.x,a.y)
	end

	LG.setColor(Palette[EC.pure_white])
end

local function damage(a,d)
	if not a.delete then
		sfx.play(a.hitsfx,a.x,a.y)

		if flags.get(a.flags,Enums.flags.damageable) then
			a.hp = a.hp - d
			if _G[EA[a.t]]["damage"] then
				_G[EA[a.t]]["damage"](a)
			end
			--for i=1,8 do
			for i=1,4 do
				actor.make(EA.effect,EA.effects.debris,a.x,a.y)
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
					end
				end

				if flags.get(a.flags,Enums.flags.explosive) then
					actor.make(EA.effect,EA.effects.explosion,a.x,a.y,0,0,EC.white,20*(a.size))
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

local function collision(x,y,enemy)
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
--]]
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
	
	local body=actor.make(EA.effect,EA.effects.debris,a.x,a.y)
	body.decel=0.1
	if not hack then
		local choice=math.choose(1,2)
		if choice==1 then
			local imgdata=Canvas.game:newImageData(ix,iy,tw,th)
			body.image=LG.newImage(imgdata)
		else
			local imgdata=Canvas.game:newImageData(ix,iy,tw/2,th)
			body.image=LG.newImage(imgdata)
			body.d=dir

			local body2=actor.make(EA.effect,EA.effects.debris,a.x,a.y)
			body2.decel=0.1
			local imgdata2=Canvas.game:newImageData(ix+tw/2,iy,tw/2,th)
			body2.image=LG.newImage(imgdata2)
			body2.d=dir+math.randomfraction(0.5)-0.25
		end
	else
		body.decel=0.2
		local imgdata=Canvas.game:newImageData(ix,iy,tw/2,th/2)
		body.image=LG.newImage(imgdata)
		body.d=math.randomfraction(math.pi*2)

		local body2=actor.make(EA.effect,EA.effects.debris,a.x,a.y)
		body2.decel=0.2
		local imgdata2=Canvas.game:newImageData(ix+tw/2,iy+th/2,tw/2,th/2)
		body2.image=LG.newImage(imgdata2)
		body2.d=math.randomfraction(math.pi*2)

		local body3=actor.make(EA.effect,EA.effects.debris,a.x,a.y)
		body3.decel=0.2
		local imgdata3=Canvas.game:newImageData(ix+tw/2,iy,tw/2,th/2)
		body3.image=LG.newImage(imgdata3)
		body3.d=math.randomfraction(math.pi*2)

		local body4=actor.make(EA.effect,EA.effects.debris,a.x,a.y)
		body4.decel=0.2
		local imgdata4=Canvas.game:newImageData(ix,iy,tw/2,th/2)
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