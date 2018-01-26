local function make(a)
	a.angle=-0.79--TODO put this in actor.make
	a.delta=0--NOTE need this bc actor.make sets delta to Game.timer, so any actor not spawning at Game.timer==0 can't shoot
	
	module.make(a,EM.sound,10,"get")
	return a
end

local function control(a,gs)
	
	if Game.players then
		--p=Game.players[1]
		players=Game.players
		for i,p in ipairs(players) do
			--if actor.collision(a.x,a.y,p) then
			if actor.collision(a.x,a.y,p) then
				--if Game.player.controller.action.action or #Game.player.inventory<1 then

				--TODO make this game-specific, or make pickup styles or something
				--if p.controller.action.action or #p.inventory<1 then
				if p.controller.action.action and #p.inventory<1 then
					if a.sound then
						if a.sound.get then
							sfx.play(a.sound.get)
						end
					end

					a.flags=flags.set(a.flags,EF.persistent)
					--table.insert(Game.player.inventory,1,a)
					table.insert(p.inventory,1,a)
				end
			end
		end
	else
		local p=Game.player
		if actor.collision(a.x,a.y,p) then
			--if Game.player.controller.action.action or #Game.player.inventory<1 then

			--TODO make this game-specific, or make pickup styles or something
			--if p.controller.action.action or #p.inventory<1 then
			if p.controller.action.action or #p.inventory<1 then
				if a.sound then
					if a.sound.get then
						sfx.play(a.sound.get)
					end
				end

				a.flags=flags.set(a.flags,EF.persistent)
				--table.insert(Game.player.inventory,1,a)
				table.insert(p.inventory,1,a)
			end
		end
	end
	--if actor.collision(a.x,a.y,Game.player) then

end

local function carry(a,user)
	if user.tail then
		a.x=user.tail.x
		a.y=user.tail.y
	elseif user.hand then
		a.x=user.hand.x
		a.y=user.hand.y
--[[
		if not user.controller.action.action then
			a.tip.x=a.x+(math.cos(user.angle)*a.l)
			a.tip.y=a.y+(math.sin(user.angle)*a.l)
		else
			a.tip.x=a.x+(math.cos(a.angle)*a.l)
			a.tip.y=a.y+(math.sin(a.angle)*a.l)
		end
--]]
	end
end

local function use(a,gs,user,vx,vy,shoot)
	a.angle=vector.direction(vx,vy)
	a.vec[1]=math.cos(a.angle)
	a.vec[2]=math.sin(a.angle)

	if a.delta<=0 then
		if shoot then
			sfx.play(a.snd,a.x,a.y)
			run(EA[Game.name][a.t],"shoot",a,gs)
			a.delta=a.rof
		end
	else 
		a.delta=a.delta-1*gs
	end
end

return
{
	make = make,
	control = control,
	carry = carry,
	use = use,
}