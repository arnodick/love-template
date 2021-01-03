local bighands={}

local actors={}
actors.bighands_beam={}
actors.bighands_beam.make = function(g,a,gx,gy,ga)
	a.gx=gx or 1
	a.gy=gy or 1
	a.ga=ga or 1
end
actors.bighands_beam.control = function(g,a,gs)
---[[
	local dam=0.1
	for i,enemy in ipairs(g.actors) do
		if flags.get(enemy.flags,EF.shootable) then
			if not enemy.delete then
				local ld=vector.direction(enemy.x,enemy.y,a.gx,a.gy)
				--TODO: fix this so that it doesnt jump from 0 to 1 when you try to check if ld is > gun angle
				if ld>a.ga-0.02*math.pi*2 and ld<a.ga+0.02*math.pi*2 then
					local dist=200
					actor.damage(g,enemy,dam)
				end
			end
		end
	end
--]]
	if g.timer-a.delta>=gs*4 then
		a.delete=true
	end
end
actors.bighands_beam.draw = function(g,a)
	local dist=vector.distance(a.x,a.y,a.gx,a.gy)
	--local dir=vector.direction(a.x,a.y,a.gx,a.gy)
	local dir=a.ga
	--LG.points(a.gx,a.gy,a.x,a.y)
	
---[[
	for i=0,dist,2 do
		local vx,vy=vector.vectors(dir)
		local x,y=a.gx+vx*i,a.gy+vy*i
		LG.circle("fill",x,y,3)
	end
--]]
end

actors.wand={}
actors.wand.make = function(g,a,c,user)
	a.spr=209
	a.size=1
	a.snd=11
	a.rof=4
	a.l=4
	a.tip={x=0,y=0}
	--a.angle=a.d
	--a.d=-a.d
	module.make(g,a,EM.item)
end
actors.wand.control = function(g,a)
	local vx,vy=vector.vectors(a.angle)
	a.tip.x=a.x+vx*a.l
	a.tip.y=a.y+vy*a.l
end
actors.wand.shoot = function(g,a)
	local r=ray.cast(g,a.tip.x,a.tip.y,a.angle,250,1)
	local r=ray.cast(g,a.tip.x,a.tip.y,a.angle,250,1)

	local vx,vy=vector.vectors(r.d)
	lx=vx*r.len
	ly=vy*r.len

	actor.make(g,"bighands_beam",a.tip.x+lx,a.tip.y+ly,r.d,0,a.tip.x,a.tip.y,r.d)
end

actors.witch={}
actors.witch.make = function(g,a,c,size,spr,hp)
	local e=Enums

	a.size=size or 1
	a.spr=spr or 193
	a.hp=hp or 8

	a.hand={l=8,d=math.pi/4,x=0,y=0}
	local vx,vy=vector.vectors(a.d+a.hand.d)
	a.hand.x=a.x+vx*a.hand.l
	a.hand.y=a.y+vy*a.hand.l

	module.make(g,a,EM.sound,4,"damage")
	module.make(g,a,EM.hitradius,4)
	module.make(g,a,EM.inventory,1)

	a.flags=flags.set(a.flags,EF.damageable,EF.shootable)
end
actors.witch.control = function(g,a)
	if g.players[1] then
		if not a.controller then
			module.make(g,a,EM.controller,EMC.move,EMCI.ai,g.players[1])
			module.make(g,a,EM.controller,EMC.action,EMCI.ai,0.01,0)
		end
	else
		a.controller=nil
	end

	local vx,vy=vector.vectors(a.angle+a.hand.d)
	a.hand.x=a.x+vx*a.hand.l
	a.hand.y=a.y+vy*a.hand.l

	if a.controller then
		local c=a.controller.move
		if not a.controller.action.action then
			if not a.transition then
				if c then
					if c.horizontal~=0 or c.vertical~=0 then
						local controllerdirection=vector.direction(c.horizontal,-c.vertical)
						local controllerdifference=controllerdirection+a.angle
						local controllerdifference2=a.angle-(math.pi*2-controllerdirection)
						if math.abs(controllerdifference)>math.abs(controllerdifference2) then
							controllerdifference=controllerdifference2
						end
						module.make(g,a,EM.transition,easing.linear,"angle",a.angle,-controllerdifference,math.abs(controllerdifference*5))
					end
				end
			end
		else
			a.angle=vector.direction(a.controller.aim.horizontal,a.controller.aim.vertical)
			a.d=a.angle
		end
	end

	if a.vel>0 then
		if not a.animation then
			module.make(g,a,EM.animation,EM.animations.frames,10,4)
		end
	else
		if a.animation then
			a.animation=nil
		end
	end
end

bighands.actor={}
bighands.actor.make = function(g,a,...)
	if actors[a.t] then
		actors[a.t].make(g,a,...)
	end
end
bighands.actor.control = function(g,a,gs)
	if actors[a.t].control then
		actors[a.t].control(g,a,gs)
	end
end
bighands.actor.draw = function(g,a)
	if actors[a.t].draw then
		actors[a.t].draw(g,a)
	end
end

bighands.level={}

bighands.player={}
bighands.player.make = function(g,a)
	local playernum=#g.players
	print(playernum)

	actor.make(g,"wand",a.x+20,a.y)

	-- a.hand={l=8,d=math.pi/4,x=0,y=0}
	-- local vx,vy=vector.vectors(a.d+a.hand.d)
	-- a.hand.x=a.x+vx*a.hand.l
	-- a.hand.y=a.y+vy*a.hand.l
end
bighands.player.control = function(g,a)
	g.camera.x=a.x
	g.camera.y=a.y
end

bighands.make = function(g)

end

bighands.gameplay={}
bighands.gameplay.make = function(g)
	love.keyboard.setTextInput(false)
	--local zoomchange=4-g.camera.zoom
	--module.make(g,g.camera,EM.transition,easing.inOutSine,"zoom",g.camera.zoom,zoomchange,60)
	level.make(g,1,Enums.modes.topdown_tank)
	local m=g.level.map
	local a=actor.make(g,"witch",m.width/2,m.height/2)
	-- print(a)
	game.player.make(g,a)
end
bighands.gameplay.keypressed = function(g,key)
	if key=='escape' then
		game.state.make(g,"title")
	end
end
bighands.gameplay.gamepadpressed = function(g,joystick,button)
	if button=="start" then
		g.pause = not g.pause
	elseif button=="a" then
		--print(joystick:getID())
		if #Joysticks>#g.players then
			local m=g.level.map
			local a=actor.make(g,"witch",m.width/2+5,m.height/2)
			game.player.make(g,a)
		end
	end
end

bighands.title={}
bighands.title.keypressed = function(g,key)
	if game.keyconfirm(key) then
		game.state.make(g,"gameplay")
	elseif key=='escape' then
		game.state.make(g,"intro")
	end
end
bighands.title.gamepadpressed = function(g,joystick,button)
	if button=="start" or button=="a" then
		game.state.make(g,"gameplay")
	elseif button=="b" then
		game.state.make(g,"intro")
	end
end
bighands.title.draw = function(g)
	LG.print("bighands title", g.width/2, g.height/2)
end

bighands.intro={}
bighands.intro.keypressed = function(g,key)
	if game.keyconfirm(key) then
		game.state.make(g,"title")
	end
end
bighands.intro.gamepadpressed = function(g,joystick,button)
	if button=="start" or button=="a" then
		game.state.make(g,"title")
	end
end
bighands.intro.draw = function(g)
	LG.print("bighands intro", g.width/2, g.height/2)
end

bighands.item={}
bighands.item.control = function(g,a,gs)
	local players=g.players
	for i,p in ipairs(players) do
		if actor.collision(a.x,a.y,p) then
			if p.controller.action.action and #p.inventory<1 then
				if a.sound then
					if a.sound.get then
						sfx.play(g,a.sound.get)
					end
				end
				a.flags=flags.set(a.flags,EF.persistent)
				table.insert(p.inventory,1,a)
			end
		end
	end	
end
bighands.item.carry = function(g,a,user)
	a.x=user.hand.x
	a.y=user.hand.y
end

return bighands