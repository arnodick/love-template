local function make(t,st,x,y,d,vel,...)
	local a={}
	a.t=t
	a.st=st
	a.x=x or love.math.random(320)
	a.y=y or love.math.random(240)
	a.d=d or 0
	a.vel=vel or 0
	a.vec={math.cos(a.d),math.sin(a.d)}
	a.angle=0
	a.delta=Timer
	a.delete=false
	a.flags = 0x0
	if _G[Enums.actors[a.t]]["make"] then
		_G[Enums.actors[a.t]]["make"](a,...)
	end
	table.insert(Actors,a)
	return a
end

local function control(a,gs)
	counters.update(Game.settings.counters,a)
	controller.update(a,gs)

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
	local xcell,ycell=map.getcell(Game.settings.map,a.x,a.y)
	local xdest,ydest=a.x + a.vec[1]*a.vel*gs,a.y - a.vec[2]*a.vel*gs
	local xcelldest,ycelldest=map.getcell(Game.settings.map,xdest,ydest)
	
	local xmapcell=Game.settings.map[ycell][xcelldest]
	local ymapcell=Game.settings.map[ycelldest][xcell]
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
		if _G[Enums.actors[a.t]]["collision"] then
			_G[Enums.actors[a.t]]["collision"](a)
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
			if a.vel<=a.decel*(Timer-a.delta)/4 then
				a.vel = 0
				a.decel = 0
			else
				a.vel = a.vel - a.decel*gs*(Timer-a.delta)/4
			end
		elseif a.vel<0 then
			if a.vel>=-a.decel*(Timer-a.delta)/4 then
				a.vel = 0
				a.decel = 0
			else
				a.vel = a.vel + a.decel*gs*(Timer-a.delta)/4
			end
		end
	end

	if _G[Enums.actors[a.t]]["control"] then
		_G[Enums.actors[a.t]]["control"](a,gs)
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
	if _G[Enums.actors[a.t]]["predraw"] then
		_G[Enums.actors[a.t]]["predraw"](a)
	end

	love.graphics.setColor(Palette[a.c])
	sprites.draw(a)

	if _G[Enums.actors[a.t]]["draw"] then
		_G[Enums.actors[a.t]]["draw"](a)
	end

	if DebugMode then
		if a.hitbox then
			love.graphics.setColor(Palette[Enums.colours.blue])
			--love.graphics.rectangle("line",a.x+a.hitbox.x,a.y+a.hitbox.y,a.hitbox.w,a.hitbox.h)
			love.graphics.circle("line",a.x,a.y,a.hitbox.w/2)
		end
		love.graphics.setColor(Palette[Enums.colours.blue])
		love.graphics.points(a.x,a.y)
	end

	love.graphics.setColor(Palette[Enums.colours.pure_white])
end

local function damage(a,d)
	local e=Enums
	if not a.delete then
		sfx.play(a.hitsfx,a.x,a.y)

		if flags.get(a.flags,Enums.flags.damageable) then
			a.hp = a.hp - d
			if _G[Enums.actors[a.t]]["damage"] then
				_G[Enums.actors[a.t]]["damage"](a)
			end
			--for i=1,8 do
			for i=1,4 do
				actor.make(e.actors.effect,e.actors.effects.debris,a.x,a.y)
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
						Game.settings.score=Game.settings.score+a.value
					end
				end

				if flags.get(a.flags,Enums.flags.explosive) then
					actor.make(e.actors.effect,e.actors.effects.explosion,a.x,a.y,0,0,e.colours.white,20*(a.size))
				end

				if _G[Enums.actors[a.t]]["dead"] then
					_G[Enums.actors[a.t]]["dead"](a)
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
	if dist<enemy.hitbox.w/2 then--TODO put failsafe here?
		return true
	else
		return false
	end
--[[
	if enemy.hitbox then
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
	local e=Enums
	local dir=math.randomfraction(math.pi*2)
	--local tw,th=iw,ih
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
	
	local body=actor.make(e.actors.effect,e.actors.effects.debris,a.x,a.y)
	body.decel=0.1
	if not hack then
		local choice=math.choose(1,2)
		if choice==1 then
			local imgdata=Canvas.game:newImageData(ix,iy,tw,th)--TODO this crashes if it goes off canvas. clamp it
			body.image=love.graphics.newImage(imgdata)
		else
			local imgdata=Canvas.game:newImageData(ix,iy,tw/2,th)--TODO this crashes if it goes off canvas. clamp it
			body.image=love.graphics.newImage(imgdata)
			body.d=dir

			local body2=actor.make(e.actors.effect,e.actors.effects.debris,a.x,a.y)
			body2.decel=0.1
			local imgdata2=Canvas.game:newImageData(ix+tw/2,iy,tw/2,th)--TODO this crashes if it goes off canvas. clamp it
			body2.image=love.graphics.newImage(imgdata2)
			body2.d=dir+math.randomfraction(0.5)-0.25
		end
	else
		body.decel=0.2
		local imgdata=Canvas.game:newImageData(ix,iy,tw/2,th/2)
		body.image=love.graphics.newImage(imgdata)
		body.d=math.randomfraction(math.pi*2)

		local body2=actor.make(e.actors.effect,e.actors.effects.debris,a.x,a.y)
		body2.decel=0.2
		local imgdata2=Canvas.game:newImageData(ix+tw/2,iy+th/2,tw/2,th/2)--TODO this crashes if it goes off canvas. clamp it
		body2.image=love.graphics.newImage(imgdata2)
		body2.d=math.randomfraction(math.pi*2)

		local body3=actor.make(e.actors.effect,e.actors.effects.debris,a.x,a.y)
		body3.decel=0.2
		local imgdata3=Canvas.game:newImageData(ix+tw/2,iy,tw/2,th/2)--TODO this crashes if it goes off canvas. clamp it
		body3.image=love.graphics.newImage(imgdata3)
		body3.d=math.randomfraction(math.pi*2)

		local body4=actor.make(e.actors.effect,e.actors.effects.debris,a.x,a.y)
		body4.decel=0.2
		local imgdata4=Canvas.game:newImageData(ix,iy,tw/2,th/2)--TODO this crashes if it goes off canvas. clamp it
		body4.image=love.graphics.newImage(imgdata4)
		body4.d=math.randomfraction(math.pi*2)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
	collision = collision,
	damage = damage,
	impulse = impulse,
	corpse = corpse,
}