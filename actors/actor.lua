local function make(t,st,x,y,c,d,vel,...)
	local a={}
	a.t=t
	a.st=st
	a.x=x
	a.y=y
	a.cinit=c or Enums.colours.red 
	a.c=a.cinit
	a.d=d or 0
	a.vel=vel or 0
	a.vec={math.cos(a.d),math.sin(a.d)}
	a.angle=0
	a.delta=Timer
	a.accel=0.08
	a.decel=0
	a.maxvel=5
	a.delete=false
	a.flags = 0x0
	--a.flags = actor.setflags( 0x0, Enums.flags.gravity,Enums.flags.explosive,Enums.flags.ground_delta)
	if _G[Enums.actornames[a.t]]["make"] then
		_G[Enums.actornames[a.t]]["make"](a,...)
	end
	table.insert(Actors,a)
	return a
end

local function control(a,gs)
	controller.update(a,gs)

	if _G[Enums.actornames[a.t]]["control"] then
		_G[Enums.actornames[a.t]]["control"](a)
	end

	if a.anglespeed then
		a.angle = a.angle + a.anglespeed*a.vec[1]*math.pi*2*gs
	end

	if a.hit then
		if a.hit>0 then
			a.hit=a.hit-gs
		else
			a.c=a.cinit --TODO make this an init value
		end
	end

	a.vec[1] = math.cos(a.d)
	a.vec[2] = math.sin(a.d)
	a.x = a.x + a.vec[1]*a.vel*gs
	a.y = a.y - a.vec[2]*a.vel*gs

	if a.vel>0 then
		if a.vel<a.decel then
			a.vel = 0
		else
			a.vel = a.vel - a.decel*gs
		end
	elseif a.vel<0 then
		if a.vel>-a.decel then
			a.vel = 0
		else
			a.vel = a.vel + a.decel*gs
		end
	end

	if a.x<-10
	or a.x>330
	or a.y>250
	or a.y<-10 then
		if not actor.getflag(a.flags,Enums.flags.persistent) then
			a.delete=true
	 	end
	end
end

local function draw(a)
	love.graphics.setColor(Palette[a.c])

	sprites.draw(a)

	if _G[Enums.actornames[a.t]]["draw"] then
		_G[Enums.actornames[a.t]]["draw"](a)
	end

	if a.gun then
		gun.draw(a.gun)
	end

	if DebugMode then
		if a.hitbox then
			love.graphics.setColor(Palette[Enums.colours.blue])
			love.graphics.rectangle("line",a.x+a.hitbox.x,a.y+a.hitbox.y,a.hitbox.w,a.hitbox.h)
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

		if actor.getflag(a.flags,Enums.flags.damageable) then
			a.hp = a.hp - d-- or 3
			for i=1,8 do
				actor.make(e.actors.effect,e.effects.spark,a.x,a.y)
			end
			--TODO dynamicalize damage function for each actor?
			if a.ct==e.controllers.gamepad then
				Camera.shake=20
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
				Game.settings.score=Game.settings.score+1
				if actor.getflag(a.flags,Enums.flags.explosive) then
					actor.make(e.actors.effect,e.effects.explosion,a.x,a.y,Enums.colours.white,0,0,20*(a.size))
				end
				--HACK TO GET ENEMIES TO SPAWN
				if a.ct==Enums.controllers.enemy then
					actor.make(e.actors.character,e.characters.snake,math.random(320),math.random(240),e.colours.dark_green,0,0,49,1,8,e.controllers.enemy)
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
end

local function getflag(bytes,f)
	--takes an actor's hex flags attribute and an integer flag position
	--returns true if that flag position is set
	local flag = 2^(f-1) --converts flag position to its actual hex number value (ie: f 1 = 1, f 2 = 2, f 3 = 4, f 4 = 8 etc.)
	if bit.band(bytes,flag) == flag then --checks if flag f is set in actor's flags. ignores other flags.
		return true
	else
		return false
	end
end

local function setflags(bytes,...)
	--takes an actor's hex flag attribute and a table of flag positions
	--SWITCHES the bit pointed to by each flag position
	--doesn't just turn ON bits, can turn OFF a bit by using a flag position that has already been set in the byte
	--returns updated flags
	local flags={...}
	for a=1,#flags do
		--print(flags[a])
		local flag = 2^(flags[a]-1) --converts flag position to its actual hex number value (ie: f 1 = 1, f 2 = 2, f 3 = 4, f 4 = 8 etc.)
		bytes=bit.bxor(bytes,flag)
	end
	return bytes
end

return
{
	make = make,
	control = control,
	draw = draw,
	collision = collision,
	damage = damage,
	impulse = impulse,
	getflag = getflag,
	setflags = setflags,
}