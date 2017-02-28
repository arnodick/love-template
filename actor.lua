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

	if _G[Enums.actors[a.t]]["control"] then
		_G[Enums.actors[a.t]]["control"](a,gs)
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

	gun.draw(a.gun)

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
				--if a.st~=Enums.actors.characters.player then
				--if not flags.get(a.flags,Enums.flags.player) then
				if Player.hp>0 then
					if a.value then
						Game.settings.score=Game.settings.score+a.value
					end
				end
				--end
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
	if dist<enemy.hitbox.w/2 then
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

return
{
	make = make,
	control = control,
	draw = draw,
	collision = collision,
	damage = damage,
	impulse = impulse,
}