local function make(a,gc,bc,shopitem,...)
	local ea=Enums.actors
	local ec=Enums.colours
	a.c=gc
	a.bc=bc
	a.leninit=len or 9
	a.len=a.leninit
	a.anglemin=-math.pi
	a.anglemax=0
	a.angle=-0.79
	a.mx=a.x-math.cos(a.angle+0.1)*a.len/2
	a.my=a.y-math.sin(a.angle+0.1)*a.len/2
	a.tx=a.x-math.cos(a.angle)*a.len
	a.ty=a.y-math.sin(a.angle)*a.len
	a.getsfx=10
	a.delta=0--NOTE need this bc actor.make sets delta to Timer, so any actor not spawning at Timer==0 can't shoot
	if shopitem then
		a.flags=flags.set(a.flags,Enums.flags.shopitem)
	end
	if _G[ea.items[a.st]]["make"] then
		_G[ea.items[a.st]]["make"](a)
	end
	return a
end

local function control(a,gs)
	local e=Enums
	--if #Player.inv<1 then
	if actor.collision(a.x,a.y,Player) then	
		if Player.controller.powerup or #Player.inv<1 then
			if a.getsfx then
				sfx.play(a.getsfx)
			end
			table.insert(Player.inv,1,a)
		end
	end
	if _G[e.actors.items[a.st]]["control"] then
		_G[e.actors.items[a.st]]["control"](a,gs)
	end
end

local function use(a,gs,user,vx,vy,shoot)
	local e=Enums
	a.angle=vector.direction(vx,vy)
	a.vec[1]=math.cos(a.angle)
	a.vec[2]=math.sin(a.angle)

	a.x=user.x+a.vec[1]*a.len
	a.y=user.y+a.vec[2]*a.len

	if a.delta<=0 then
		if shoot then
			sfx.play(a.snd,a.x,a.y)

			if _G[e.actors.items[a.st]]["shoot"] then
				_G[e.actors.items[a.st]]["shoot"](a,gs)
			end

			actor.make(e.actors.effect,e.actors.effects.cloud,a.x,a.y,-a.angle+math.randomfraction(1)-0.5,math.randomfraction(1))
			a.delta=a.rof
		end
	else 
		a.delta = a.delta - 1*gs
	end
end

local function draw(a)
	if _G[Enums.actors.items[a.st]]["draw"] then
		_G[Enums.actors.items[a.st]]["draw"](a,gs)
	end
end

return
{
	make = make,
	control = control,
	use = use,
	draw = draw,
}