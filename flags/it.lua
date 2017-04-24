local function make(a,gc,bc,shopitem,...)
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
	a.delta=0--NOTE need this bc actor.make sets delta to Game.timer, so any actor not spawning at Game.timer==0 can't shoot
	if shopitem then
		a.flags=flags.set(a.flags,EF.shopitem)
	end
	if _G[EA.items[a.st]]["make"] then
		_G[EA.items[a.st]]["make"](a)
	end
	return a
end

local function control(a,gs)
	if actor.collision(a.x,a.y,Player) then	
		if Player.controller.powerup or #Player.inv<1 then
			if a.getsfx then
				sfx.play(a.getsfx)
			end
			a.flags=flags.set(a.flags,EF.persistent)
			table.insert(Player.inv,1,a)
		end
	end
	if _G[EA.items[a.st]]["control"] then
		_G[EA.items[a.st]]["control"](a,gs)
	end
end

local function carry(a,user)
	a.x=user.tail.x
	a.y=user.tail.y
end

local function use(a,gs,user,vx,vy,shoot)
	a.angle=vector.direction(vx,vy)
	a.vec[1]=math.cos(a.angle)
	a.vec[2]=math.sin(a.angle)

--[[
	a.x=user.tail.x
	a.y=user.tail.y
--]]

	if a.delta<=0 then
		if shoot then
			sfx.play(a.snd,a.x,a.y)

			if _G[EA.items[a.st]]["shoot"] then
				_G[EA.items[a.st]]["shoot"](a,gs)
			end

			actor.make(EA.effect,EA.effects.cloud,a.x,a.y,-a.angle+math.randomfraction(1)-0.5,math.randomfraction(1))
			a.delta=a.rof
		end
	else 
		a.delta = a.delta - 1*gs
	end
end

local function draw(a)
	if _G[EA.items[a.st]]["draw"] then
		_G[EA.items[a.st]]["draw"](a,gs)
	end
end

return
{
	make = make,
	control = control,
	carry = carry,
	use = use,
	draw = draw,
}