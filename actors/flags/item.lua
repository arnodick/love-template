local function make(a,gc,bc,shopitem)
	a.c=gc--can go in individual item's input
	a.bc=bc--can go in machinegun input
	a.angle=-0.79
	a.getsfx=10
	a.delta=0--NOTE need this bc actor.make sets delta to Game.timer, so any actor not spawning at Game.timer==0 can't shoot
	if shopitem then
		a.flags=flags.set(a.flags,EF.shopitem)
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

			actor.make(EA.cloud,a.x,a.y,-a.angle+math.randomfraction(1)-0.5,math.randomfraction(1))
			a.delta=a.rof
		end
	else 
		a.delta = a.delta - 1*gs
	end
end

return
{
	make = make,
	control = control,
	carry = carry,
	use = use,
}