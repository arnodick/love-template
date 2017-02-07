local function make(t,st,x,y,c,d,vel,...)
	local a={}
	a.t=t
	a.st=st
	a.x=x
	a.y=y
	a.c=c or Enums.colours.red
	a.d=d or 0
	a.vel=vel or 0
	a.vec={math.cos(a.d),math.sin(a.d)}
	a.delta=Timer
	a.accel=0.08
	a.decel=0.02
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
	if a.controller then
		controller.update(a.controller,a.ct)
	end

	if _G[Enums.actornames[a.t]]["control"] then
		_G[Enums.actornames[a.t]]["control"](a)
	end

	a.vec[1] = math.cos(a.d)
	a.vec[2] = math.sin(a.d)
	a.x = a.x + a.vec[1]*a.vel*gs
	a.y = a.y - a.vec[2]*a.vel*gs

	if a.gun then
		gun.control(a.gun,gs,a,a.controller[Enums.buttons.rightstickhorizontal],a.controller[Enums.buttons.rightstickvertical],a.controller[Enums.buttons.button1])
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

	love.graphics.setColor(Palette[Enums.colours.pure_white])
end

local function damage(a,d)

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

local function collision(a,enemy)
	if enemy.hitbox then
		if a.x>enemy.x+enemy.hitbox.x then
		if a.x<enemy.x+enemy.hitbox.x+enemy.hitbox.w then
		if a.y>enemy.y+enemy.hitbox.y then
		if a.y<enemy.y+enemy.hitbox.y+enemy.hitbox.h then
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