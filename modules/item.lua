local function make(a)
	a.angle=-0.79--TODO put this in actor.make
	a.delta=0--NOTE need this bc actor.make sets delta to Game.timer, so any actor not spawning at Game.timer==0 can't shoot
	
	module.make(a,EM.sound,10,"get")
	return a
end

local function control(a,gs)
	if actor.collision(a.x,a.y,Game.player) then	
		if Game.player.controller.action.action or #Game.player.inventory<1 then
			if a.sound then
				if a.sound.get then
					sfx.play(a.sound.get)
				end
			end

			a.flags=flags.set(a.flags,EF.persistent)
			table.insert(Game.player.inventory,1,a)
		end
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

			if _G[EA[Game.name][a.t]]["shoot"] then
				_G[EA[Game.name][a.t]]["shoot"](a,gs)
			end

			actor.make(Game,EA[Game.name].cloud,a.x,a.y,-a.angle+math.randomfraction(1)-0.5,math.randomfraction(1))
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