local function make(t,x,y,d,vel)
	local actor={}
	actor.t=t
	actor.x=x
	actor.y=y
	actor.d=d
	actor.vec={math.cos(d),math.sin(d)}
	actor.vel=vel
	actor.grav=true
	actor.delta=Timer
	actor.accel=0.08
	actor.decel=0.02
	actor.maxvel=5
	_G[Enums.names[actor.t]]["make"](actor)
	table.insert(Actors,actor)
	return actor
end

local function control(a)
	_G[Enums.names[a.t]]["control"](a)
end

local function draw(a)
	_G[Enums.names[a.t]]["draw"](a)
end

local function makehitbox(a,x,y,w,h)
	a.hitbox={}
	a.hitbox.x=x
	a.hitbox.y=y
	a.hitbox.w=w
	a.hitbox.h=h
end

return
{
	make = make,
	control = control,
	draw = draw,
	makehitbox = makehitbox,
}