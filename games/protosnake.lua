local protosnake={}

protosnake.make = function(g)
	-- g.window={}
 --    g.window.width=640
 --    g.window.height=480

	g.levelpath={}
end

local actors={}
actors.beam={}
actors.beam.make = function(g,a,gx,gy,ga)
	a.gx=gx or 1
	a.gy=gy or 1
	a.ga=ga or 1
	a.c=c or "blue"
end
actors.beam.control = function(g,a,gs)
	local dam=0
	for i,enemy in ipairs(g.actors) do
		if flags.get(enemy.flags,EF.shootable) then
			if not enemy.delete then
				local ld=vector.direction(a.gx,a.gy,enemy.x,enemy.y)
				--TODO: fix this so that it doesnt jump from 0 to 1 when you try to check if ld is > gun angle
				if ld>a.ga-0.02*math.pi*2 and ld<a.ga+0.02*math.pi*2 then
					local dist=200
					actor.damage(g,enemy,0)
				end
			end
		end
	end
	if g.timer-a.delta>=gs*3 then
		a.delete=true
	end
end
actors.beam.draw = function(g,a)
	local dist=vector.distance(a.x,a.y,a.gx,a.gy)
	local dir=vector.direction(a.x,a.y,a.gx,a.gy)
	for i=10,dist,5 do
		local x,y=a.gx+math.cos(dir)*i,a.gy+math.sin(dir)*i
		LG.circle("fill",x,y,6)
	end
end

actors.bullet={}
actors.bullet.make = function(g,a,c)
	a.cinit=c or "green"
	a.c=a.cinit
	a.spr=65
	a.size=1
	a.angle=-a.d
	--a.draw=false
end
actors.bullet.control = function(g,a)
	local dam=1
	for i,enemy in ipairs(g.actors) do
		if flags.get(enemy.flags,EF.shootable) then
			if not enemy.delete then
				if actor.collision(a.x,a.y,enemy) then
					a.delete=true
					actor.damage(g,enemy,dam)
				end
			end
		end
	end
end
actors.bullet.collision = function(g,a)
	a.delete=true
end

actors.cloud={}
actors.cloud.make = function(g,a,c,size)
	a.cinit=c or "indigo"
	a.c=a.cinit
	a.size=size or 6
	a.angle=-a.d
	a.anglespeed=0.02
	a.pointdirs={}
	for i=0,3 do
		table.insert(a.pointdirs, math.randomfraction(math.pi/2) + (math.pi/2)*i )
	end
	a.r=size
	a.alpha=1
	a.flags=flags.set(a.flags,EF.bouncy)
end
actors.cloud.control = function(g,a)
	local delta=g.timer-a.delta
	a.r=a.size-delta/5
	-- a.alpha=a.alpha-2
	a.alpha=a.alpha-0.01
	if a.r<1 then
		a.delete=true
	end
end
actors.cloud.draw = function(g,a)
	local points={}
	for i=1,#a.pointdirs do
		table.insert(points,a.x+math.cos(a.pointdirs[i]+a.angle)*a.r)
		table.insert(points,a.y+math.sin(a.pointdirs[i]+a.angle)*a.r/2.5)
	end
	LG.polygon("fill",points)
--[[
	LG.setCanvas(g.level.canvas.background)
		local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
		LG.translate(xcamoff,ycamoff)
			LG.polygon("fill",points)
		LG.translate(-xcamoff,-ycamoff)
	LG.setCanvas(g.canvas.main)
	--]]

	if Debugger.debugging then
		LG.setColor(g.palette["green"])
		LG.points(a.x,a.y)
		LG.setColor(g.palette["red"])
		for i=1,#points,2 do
			LG.points(points[i],points[i+1])
		end
	end
end

actors.coin={}
actors.coin.make = function(g,a,c,size,spr)
	a.cinit=c or "pure_white"
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 113
	a.sprinit=a.spr

	module.make(g,a,EM.collectible)
	module.make(g,a,EM.sound,6,"get")

	a.d=math.randomfraction(math.pi*2)
	a.vel=math.randomfraction(4)+4
	a.decelinit=0.05
	a.decel=a.decelinit
	a.anglespeed=(a.vec[1]+math.choose(0,0,3,4))*(a.vel/60)
	a.anglespeeddecel=0.01
	a.scalex=1
	a.scaley=1
	a.deltimer=0
	a.follow=false
	a.value=1
	a.alpha=1
	a.flags=flags.set(a.flags,EF.bouncy)
end
actors.coin.control = function(g,a,gs)
	local e=Enums
	if a.vel<=0 then
		a.follow=true
	end
	if a.scalex>1 then
		a.scalex=a.scalex-0.1*gs
	end
	if a.scaley>1 then
		a.scaley=a.scaley-0.1*gs
	end
	if a.follow then
		local p=g.player
		local dist=vector.distance(a.x,a.y,p.x,p.y)
		if dist<30 then
			if not a.controller then
				module.make(g,a,EM.controller,EMC.move,EMCI.ai,p)
			end
			a.speed=8/dist
		else
			if a.controller then
				a.controller=nil
			end
			a.decel=a.decelinit
		end
	end
	if g.timer-a.delta>=120 then
		a.deltimer = a.deltimer+gs
		if a.deltimer<=80 then
			sprites.blink(g,a,14)
		else
			sprites.blink(g,a,6)
		end
		if a.deltimer>=120 then
			if a.vel==0 then
				sfx.play(g,7,a.x,a.y)
				for i=1,20 do
					actor.make(g,"cloud",a.x,a.y,math.randomfraction(math.pi*2),math.randomfraction(1))
				end
				a.delete=true
			end
		end
	end
end

actors.collectibleget={}
actors.collectibleget.make = function(g,a,c,size,spr)
	a.c=c or "pure_white"
	a.size=size or 1
	print("SPRITE IS: "..tostring(spr))
	a.spr=spr or 1
	a.scalex=1
end
actors.collectibleget.control = function(g,a)
	a.scalex=math.sin(g.timer)
	if g.timer-a.delta>=30 then
		sfx.play(g,8,a.x,a.y)
		for i=1,20 do
			actor.make(g,"spark",a.x,a.y)
			--actor.load(g,"spark",a.x,a.y,math.randomfraction(math.pi*2),nil,math.randomfraction(2)+2,"yellow")
		end
		a.delete=true
	end
end

actors.debris={}
actors.debris.make = function(g,a,c)
	a.c=c or "orange"
	a.d=math.randomfraction(math.pi*2)
	--a.vel=math.randomfraction(2)+2
	a.vel=math.randomfraction(4)+4
	a.decel=0.05
	a.anglespeed=(a.vec[1]+math.choose(0,0,3,8))*(a.vel/60)
	a.len=math.randomfraction(1)+1
	a.angleoff=math.randomfraction(math.pi)
	a.flags=flags.set(a.flags,EF.bouncy,EF.persistent)
end
actors.debris.control = function(g,a)
	if a.vel<=0 then
		a.delete=true
	end
end
actors.debris.draw = function(g,a)
	local m=g.level.map
	local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
	if a.image then
		LG.draw(a.image,a.x,a.y,a.angle,1,1,(m.tile.width)/2,(m.tile.height)/2)
		if a.vel<=0 then
			LG.drawtobackground(g,g.level.canvas.background,a.image,a.x,a.y,a.angle,1,1,(m.tile.width)/2,(m.tile.height)/2)
		end
	else
		-- print("DEBRIS DRAW")
		local xl,yl=math.cos(a.angle),math.sin(a.angle)
		local xl2,yl2=-math.cos(a.angle+a.angleoff),-math.sin(a.angle+a.angleoff)
		LG.line(a.x,a.y,a.x+xl*a.len,a.y+yl*a.len)
		--LG.line(a.x,a.y,a.x+xl*-a.len,a.y+yl*-a.len)
		LG.line(a.x,a.y,a.x+xl2*a.len,a.y+yl2*a.len)
		if a.vel<=0 then
			-- print("DEBRIS DRAW BG")
			LG.setCanvas(g.level.canvas.background)
				LG.line(a.x+xcamoff,a.y+ycamoff,a.x+xl*a.len+xcamoff,a.y+yl*a.len+ycamoff)
				--LG.line(a.x,a.y,a.x+xl*-a.len,a.y+yl*-a.len)
				LG.line(a.x+xcamoff,a.y+ycamoff,a.x+xl2*a.len+xcamoff,a.y+yl2*a.len+ycamoff)
			LG.setCanvas(g.canvas.main)
		end
	end
end

actors.explosion={}
actors.explosion.make = function(g,a,c,size)
	sfx.play(g,1,a.x,a.y)
	a.cinit=c or "white"
	a.c=a.cinit
	a.size=size or 20
	a.r=0
	g.screen.shake=a.size--TODO make shake module, does this then deletes itself
	--instead of having an explosion actor, have an explosion flag, which does all the stuff an explosion would normally do
	a.flags=flags.set(a.flags,EF.persistent)
end
actors.explosion.control = function(g,a,gs)
	local delta = (g.timer-a.delta)
	a.r = a.size*(delta/6)
	if a.r>=a.size then
		for j=1,6*a.size do
			local s = math.randomfraction(a.size/2)
			local dir = math.randomfraction(math.pi*2)
			local d = math.randomfraction(math.pi*2)
			actor.make(g,"cloud",a.x+math.cos(dir)*s,a.y+math.sin(dir)*s,d,math.randomfraction(0.5))
		end
		a.delete=true
	end
end
actors.explosion.draw = function(g,a)
	LG.circle("fill",a.x,a.y,a.r,16)
	if Debugger.debugging then
		LG.setColor(g.palette["yellow"])--TODO what was 11 beofre? yellow?
		LG.circle("line",a.x,a.y,a.r)
	end
end

actors.hammer={}
actors.hammer.make = function(g,a,c)
	a.c=c or "dark_purple"
	a.size=1
	a.sprinit=145
	a.spr=a.sprinit
	a.rof=4
	a.snd=2
	a.spd=2

	a.cost=3
	module.make(g,a,EM.hitradius,4)
	module.make(g,a,EM.item)
end
actors.hammer.control = function(g,a)
	if not flags.get(a.flags,EF.shopitem) then
		if not a.spr then
			a.spr=a.sprinit
		end
	end
	-- for i,v in ipairs(g.actors) do
	-- 	if v.t==EA.projectile then
	-- 		if actor.collision(v.x,v.y,a) then
	-- 		for i=1,20 do
	-- 			local spark=actor.make(g,EA.spark,v.x,v.y)
	-- 				spark.c=v.cinit
 --   				end
	-- 			v.delete=true
	-- 		end
	-- 	end
	-- end
end

actors.hp={}
actors.hp.make = function(g,a,c,size,spr)
	a.cinit=c or "red"
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 129
	a.sprinit=a.spr

	module.make(g,a,EM.collectible)
	module.make(g,a,EM.sound,6,"get")

	a.cost=2
	a.value=4
end

actors.key={}
actors.key.make = function(g,a,c,size,spr)
	a.cinit=c or "blue"
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 177
	a.sprinit=a.spr

	module.make(g,a,EM.collectible)
	module.make(g,a,EM.sound,6,"get")

	a.cost=0
end
actors.key.get = function(g,a)
	local port=actor.make(g,"portal",g.level.map.width/2,g.level.map.height/2+40)
	port.c="red"
	port.level=2
end

actors.lazer={}
actors.lazer.make = function(g,a)
	a.c=c or "blue"
	a.projvel=0
	a.rof=1
	a.num=1
	a.acc=0
	a.snd=25
	a.proj="beam"
end
actors.lazer.shoot = function(g,a)
	local dist=300
	local lx,ly=a.x+a.vec[1]*dist,a.y+a.vec[2]*dist
	if lx<=0 then lx=1 end
	if lx>=g.width then lx=g.width-1 end
	if ly<=0 then ly=1 end
	if ly>=g.height then ly=g.height-1 end
	actor.make(g,a.proj,lx,ly,a.angle,0,"pure_white",a.x,a.y,a.angle)
end

actors.machinegun={}
actors.machinegun.make = function(g,a,c,bc)
	a.c=c or "blue"
	a.bc=bc
	a.size=1
	a.sprinit=161
	a.spr=a.sprinit
	a.projvel=1.5
	a.rof=4
	a.num=1
	a.acc=0.015
	a.snd=2
	a.proj="bullet"
	module.make(g,a,EM.item)
end
actors.machinegun.shoot = function(g,a)
	for b=1,a.num do
		actor.make(g,"cloud",a.x,a.y,-a.angle+math.randomfraction(1)-0.5,math.randomfraction(1))
		local rand = love.math.random(-a.acc/2*100,a.acc/2*100)/50*math.pi
		actor.make(g,a.proj,a.x,a.y,-a.angle+rand,a.projvel+math.randomfraction(0.5),a.bc)
		--local d=-a.angle+rand
		--actor.load(g,"bullet",a.x,a.y,-a.angle+rand,-d,a.projvel+math.randomfraction(0.5),a.bc)
	end
end

actors.portal={}
actors.portal.make = function(g,a,c,size)
	a.cinit=c or "dark_purple"
	a.c=a.cinit
	a.sizeinit=size or 20
	a.size=a.sizeinit
	a.anglespeed=0.01
	--a.flags=flags.switch(a.flags,EF.persistent)
end
actors.portal.control = function(g,a,gs)
	a.size=math.clamp(a.size+love.math.random(8)-4,1,20)

		--TODO make this a function. in pixelmaps?
		local tw,th=a.sizeinit*2,a.sizeinit*2
		local ix,iy=a.x-tw/2,a.y-th/2
		local ix2,iy2=ix+tw,iy+th
		if ix<0 then ix=0 end
		if iy<0 then iy=0 end
		if ix2>g.width then
			local diff=ix2-g.width
			tw=tw-diff
		end
		if iy2>g.height then
			local diff=iy2-g.height
			th=th-diff
		end

	local imgdata=g.level.canvas.background:newImageData(1,1,ix,iy,tw,th)

	imgdata:mapPixel(pixelmaps.sparkle)
	imgdata:mapPixel(pixelmaps.crush)

	a.image=LG.newImage(imgdata)

	local dist=vector.distance(a.x,a.y,g.player.x,g.player.y)
	if dist<20 then
		--TODO make level.change or something
		for i,v in ipairs(g.actors) do
			--if v.t then--TODO this needs to be here due to new actors.items list style! actors.items doesn't ahve any attributes like .t, it's just a list
				if flags.get(v.flags,EF.enemy) and v.hp then
					actor.damage(g,v,v.hp)
				elseif not flags.get(v.flags,EF.persistent) then
					v.delete=true
				end
			--end
		end
		level.make(g,a.level,Enums.modes.topdown)
		g.ease=true--TODO make easing function for this. works on any number
		g.speed=0.01
		a.delete=true --TODO maybe give this a VERY low chance of not happening?
	end
end
actors.portal.draw = function(g,a)
	local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
	LG.setCanvas(g.level.canvas.background)
		LG.translate(xcamoff,ycamoff)
		LG.setColor(g.palette["pure_white"])
		-- LG.setColor(g.palette["black"])
		LG.draw(a.image,a.x,a.y,0,1,1,a.sizeinit,a.sizeinit)
		LG.setColor(g.palette[a.c])--TODO new color worky?
		local curve=love.math.newBezierCurve(
			a.x,
			a.y,
			a.x+math.cos(a.angle)*a.size/2,
			a.y+math.sin(a.angle)/2*a.size,
			a.x+math.cos(a.angle-1)*a.size,
			a.y+math.sin(a.angle-1)*a.size
		)
		local curve2=love.math.newBezierCurve(
			a.x,
			a.y,
			a.x-math.cos(a.angle)*a.size/2,
			a.y-math.sin(a.angle)/2*a.size,
			a.x-math.cos(a.angle-1)*a.size,
			a.y-math.sin(a.angle-1)*a.size)
		LG.line(curve:render(2))
		LG.line(curve2:render(2))
		LG.translate(-xcamoff,-ycamoff)
	LG.setCanvas(g.canvas.main)
end

actors.scorpion={}
actors.scorpion.make = function(g,a,c,size,spr,hp)
	a.cinit=c or "dark_blue"
	a.c=a.cinit or "blue"
	a.size=size or 1
	a.spr=spr or 81
	a.hp=hp or 8

	module.make(g,a,EM.sound,4,"damage")
	module.make(g,a,EM.animation,EM.animations.frames,10,2)
	module.make(g,a,EM.hitradius,4)
	module.make(g,a,EM.tail,a.cinit,9)
	module.make(g,a,EM.inventory,2)
	a.flags=flags.set(a.flags,EF.character,EF.damageable,EF.shootable,EF.explosive)

	--animation.make(a,2,32) --SWEET GLITCH ANIMATION
end
actors.scorpion.draw = function(g,a)
	if a.tail then
		tail.draw(g,a.tail)
	end
end

actors.snake={}
actors.snake.make = function(g,a,c,size,spr,hp)
	a.cinit=c or "dark_green"
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 49
	a.hp=hp or 8

	a.value=1

	module.make(g,a,EM.controller,EMC.aim,EMCI.ai,g.player)
	module.make(g,a,EM.controller,EMC.action,EMCI.ai,0.01,0)
	module.make(g,a,EM.sound,3,"damage")
	module.make(g,a,EM.tail,a.cinit,9)
	module.make(g,a,EM.inventory,1)
	module.make(g,a,EM.animation,EM.animations.frames,10,2)
	module.make(g,a,EM.hitradius,4)
	module.make(g,a,EM.drop,"coin")
	a.flags=flags.set(a.flags,EF.character,EF.bouncy,EF.enemy,EF.damageable, EF.shootable, EF.explosive)

	a.d=math.choose(math.pi)
	a.vel=1
	a.rage=0

	local gun=actor.make(g,"machinegun",a.x,a.y,0,0,a.cinit,"green")
	item.pickup(g,gun,a)
end
actors.snake.control = function(g,a)
	a.rage=math.floor(g.score/5)

	if love.math.random( math.max(40-(a.rage*10),10) ) == 1 then
		a.controller.action.chance[1]=1
	else
		a.controller.action.chance[1]=0
	end

	if a.rage>0 then
		local acc=0.015*(a.rage+1)*2--TODO initacc for gun
		if a.inventory[1].acc~=acc then
			a.inventory[1].acc=acc
		end
		if math.floor(g.timer/(20-a.rage*5))%2==0 then
			if a.rage==1 then
				a.c="yellow"
			else
				a.c="red"
			end
		else
			a.c=a.cinit
		end
	end

	if g.player.hp<=0 then
		for i,v in ipairs(g.actors) do
			if flags.get(v.flags,EF.enemy) then
				if v~=a then
					a.controller.aim.target=v
				end
			end
		end
	end
end
actors.snake.draw = function(g,a)
	if a.tail then
		tail.draw(g,a.tail)
	end
end

actors.spark={}
actors.spark.make = function(g,a,c)
	a.c=c or "yellow"
	a.d=math.randomfraction(math.pi*2)
	a.vel=math.randomfraction(2)+2
	a.decel=0.1
	a.flags=flags.set(a.flags,EF.bouncy,EF.persistent)
end
actors.spark.control = function(g,a)
	if a.vel<=0 then
		a.delete=true
	end
end
actors.spark.draw = function(g,a)
	LG.points(a.x,a.y)
	if a.vel<=0 then
		LG.setCanvas(g.level.canvas.background)
			local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
			LG.points(a.x+xcamoff,a.y+ycamoff)
		LG.setCanvas(g.canvas.main)
	end
end

actors.spawn={}
actors.spawn.make = function(g,a,c)
	a.x=love.math.random(319)
	a.y=love.math.random(239)
	a.cinit="blue"
	a.c=a.cinit
	a.d=0
	a.vel=0
	a.size=60
	a.flags=flags.set(a.flags,EF.enemy)--NOTE this is to make sure a bazillion spawns don't... spawn
	a.sfx=false
	local l=g.level
	a.enemyspawn=l.spawnindex
end
actors.spawn.control = function(g,a,gs)
	if a.sfx==false then
		if g.timer-a.delta>=20 then
			sfx.play(g,9,a.x,a.y)
			a.sfx=true
		end
	end

	a.size=a.size-gs
	if a.size<=0 then
		local l=g.level
		local spawnnum=a.enemyspawn

		if l.enemies[spawnnum] then
			local enemy=actor.make(g,l.enemies[spawnnum],a.x,a.y)

			--TODO make a spawn function or something that has all the drop stuff in it and put it in level load characer spawn too
			if l.actordrops then
				if l.actordrops[spawnnum] then
					module.make(g,enemy,EM.drop,l.actordrops[spawnnum])
				end
			end

			local p1=l.portal1
			if p1 then
				if p1.droppedby==spawnnum then
					module.make(g,enemy,EM.drop,"portal",1)--portal that goes to level 1
				end
			end

			local p2=l.portal2
			if p2 then
				if p2.droppedby==spawnnum then
					module.make(g,enemy,EM.drop,"portal",2)--portal that goes to level 1
				end
			end

			local pstore=l.portalstore
			if pstore then
				if pstore.droppedby==spawnnum then
					module.make(g,enemy,EM.drop,"portal","store")--portal that goes to level 1
				end
			end
		end

		for i=1,20 do
			local spark=actor.make(g,"spark",a.x,a.y)
			spark.c="dark_blue"
		end
		a.delete=true
	end
end
actors.spawn.draw = function(g,a)
	LG.rectangle("line",a.x-a.size/2,a.y-a.size/2,a.size,a.size)
end

actors.spider={}
actors.spider.make = function(g,a,c,size,spr,hp)
	a.cinit=c or "red"
	a.c=a.cinit
	a.size=size or 2
	a.spr=spr or 8
	a.hp=hp or 50

	a.value=1
	a.speed=1.5

	module.make(g,a,EM.target,g.player)
	
	--TODO make this stuff into some sort of function?
	local dir=vector.direction(a.x,a.y,a.target.x,a.target.y)
	local dist=vector.distance(a.x,a.y,a.target.x,a.target.y)*1.5
	local x=math.clamp(a.x+math.cos(dir)*dist,0,g.width)
	local y=math.clamp(a.y+math.sin(dir)*dist,0,g.height)
	module.make(g,a,EM.controller,EMC.move,EMCI.ai,x,y)

	module.make(g,a,EM.sound,3,"damage")
	module.make(g,a,EM.animation,EM.animations.frames,6,2)
	module.make(g,a,EM.hitradius,8)
	a.flags=flags.set(a.flags,EF.character,EF.enemy,EF.damageable, EF.shootable, EF.explosive)

	sfx.play(g,12)
end
actors.spider.control = function(g,a)
	if actor.collision(a.x,a.y,a.target) then
		actor.damage(g,a.target,8)
		actor.damage(g,a,a.hp)
	end

	if a.controller.move.target then
		local t=a.controller.move.target
		local targetdistance=vector.distance(a.x,a.y,t.x,t.y)
		if targetdistance<=a.vel then
			a.controller.move.target=nil
		end
	end
	if not a.controller.move.target then
		local dir=vector.direction(a.x,a.y,a.target.x,a.target.y)
		local dist=vector.distance(a.x,a.y,a.target.x,a.target.y)*1.5
		local x=math.clamp(a.x+math.cos(dir)*dist,0,g.width)
		local y=math.clamp(a.y+math.sin(dir)*dist,0,g.height)
		module.make(g,a,EM.controller,EMC.move,EMCI.ai,x,y)
		sfx.play(g,12)
	end

	if g.player.hp<=0 then
		for i,v in ipairs(g.actors) do
			if flags.get(v.flags,EF.enemy) then
				if v~=a then
					a.controller.move.target=v
				end
			end
		end
	end
end
actors.spider.dead = function(g,a)
	for i=1,3 do
		actor.make(g,"coin",a.x,a.y)
	end
end

actors.squid={}
actors.squid.make = function(g,a,c,size,spr,hp)
	a.cinit=c or "yellow"
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 97
	a.hp=hp or 16

	a.value=1
	a.speed=2

	module.make(g,a,EM.target,g.player)

	module.make(g,a,EM.controller,EMC.move,EMCI.ai,a.x,a.y)
	module.make(g,a,EM.sound,3,"damage")
	module.make(g,a,EM.animation,EM.animations.frames,10,2)
	module.make(g,a,EM.hitradius,4)
	a.flags=flags.set(a.flags,EF.character,EF.enemy,EF.damageable, EF.shootable, EF.explosive)

	--g.level.enemies.max=math.clamp(g.level.enemies.max+1,1,g.level.enemies.maxlimit)
	g.level.enemycount.max=math.clamp(g.level.enemycount.max+1,1,g.level.enemycount.maxlimit)
end
actors.squid.control = function(g,a)
	if love.math.random(10000)==1 then
		--actor.load(g,"hp",a.x,a.y)
		local smolhp=actor.make(g,"hp",a.x,a.y,0,0,"red",1,129)
		smolhp.value=1
		smolhp.scalex=0.5
		smolhp.scaley=0.5
	end

	local mindist=100
	local movedist=vector.distance(a.x,a.y,a.controller.move.target.x,a.controller.move.target.y)

	if a.target then--if you aren't running to safety
		local playerdist=vector.distance(a.x,a.y,a.target.x,a.target.y)
		if playerdist<mindist then--if player is too close and you're cornered, then run to safety
			if a.x>g.level.map.width-32 or a.x<32 or a.y>g.level.map.height-32 or a.y<32 then
				a.controller.move.target.x,a.controller.move.target.y=love.math.random(g.level.map.width-32),love.math.random(g.level.map.height-32)
				local targetdist=vector.distance(a.controller.move.target.x,a.controller.move.target.y,a.target.x,a.target.y)
				while targetdist<mindist do
					a.controller.move.target.x,a.controller.move.target.y=love.math.random(g.level.map.width-32),love.math.random(g.level.map.height-32)
					targetdist=vector.distance(a.controller.move.target.x,a.controller.move.target.y,a.target.x,a.target.y)
				end
				a.target=nil--don't worry about player any more, just get to safety
			else--if player is too close and you're not cornered, BACK OFF
				local playerdir=vector.direction(a.target.x,a.target.y,a.x,a.y)--meant to be backwards so squid goes away
				a.controller.move.target.x,a.controller.move.target.y=a.x+(math.cos(playerdir)*playerdist),a.y+(math.sin(playerdir)*playerdist)
			end
		else--if player is not close, then random jitter
			local x,y=love.math.random(g.level.map.width),love.math.random(g.level.map.height)
			local randdist=vector.distance(x,y,a.target.x,a.target.y)
			while randdist<mindist do
				x,y=love.math.random(g.level.map.width),love.math.random(g.level.map.height)
				randdist=vector.distance(x,y,a.target.x,a.target.y)
			end
			a.controller.move.target.x,a.controller.move.target.y=x,y
		end
	elseif movedist<=a.vel then--if you've made it to safety then look out for player again
		module.make(g,a,EM.target,g.player)
	end
end

actors.squid_store={}
actors.squid_store.make = function(g,a,c,size,spr,hp)
	a.cinit=c or "yellow"
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 97
	a.hp=hp or 1

	a.speed=2

	module.make(g,a,EM.controller,EMC.move,EMCI.ai,g.level.map.width/2,g.level.map.height/4*3)
	module.make(g,a,EM.sound,3,"damage")
	module.make(g,a,EM.animation,EM.animations.frames,10,2)
	module.make(g,a,EM.hitradius,4)
	a.flags=flags.set(a.flags,EF.character,EF.enemy,EF.damageable, EF.shootable, EF.explosive)
end
actors.squid_store.control = function(g,a)
	local dist=vector.distance(a.x,a.y,g.player.x,g.player.y)

	if dist<30 then
		if not a.menu then
			local zoomchange=2.5-g.camera.zoom
			module.make(g,g.camera,EM.transition,easing.inOutSine,"zoom",g.camera.zoom,zoomchange,180)
			module.make(g,a,EM.menu,"text",a.x,a.y-38,50,50,{"what you buy do you want to buy the powerup ?"},"orange","dark_green")
			local m=a.menu
			module.make(g,m,EM.border,"indigo","dark_purple")
			m.font=LG.newFont("fonts/pico8.ttf",8)--TODO put font in menu makey
		end
	elseif a.menu then
		local zoomchange=-(g.camera.zoom-1)
		module.make(g,g.camera,EM.transition,easing.inOutSine,"zoom",g.camera.zoom,zoomchange,20)
		a.menu=nil
	end

	if a.controller then
		local movedist=vector.distance(a.x,a.y,a.controller.move.target.x,a.controller.move.target.y)
		if movedist<=a.speed then
			a.vel=0
			a.controller=nil
		end
	end
end
actors.squid_store.dead = function(g,a)
	local zoomchange=-(g.camera.zoom-1)
	module.make(g,g.camera,EM.transition,easing.inOutSine,"zoom",g.camera.zoom,zoomchange,10)
end

actors.wiper={}
actors.wiper.make = function(g,a,c)
	a.c=c or "red"
	a.d=0
	a.vel=1
end
actors.wiper.draw = function(g,a)
	LG.line(a.x,0,a.x,g.level.map.height)
	LG.setCanvas(g.level.canvas.background)
		local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
		LG.translate(xcamoff,ycamoff)
			LG.setColor(g.palette["black"])
			LG.line(a.x,0,a.x,g.level.map.height)
		LG.translate(-xcamoff,-ycamoff)
	LG.setCanvas(g.canvas.main)
end
actors.wiper.collision = function(a)
	a.delete=true
end

protosnake.actors=actors

protosnake.level={}
protosnake.level.arena=
{
	make = function(g,l)
	end,

	control = function(g,l)
	end
}
protosnake.level.store=
{
	make = function(g,l)
		actor.make(g,"wiper",8,8)

		for i=1,3 do
			local storeitem=l["storeitem"..i]
			if storeitem then
				local dropname=storeitem.drop
				local x=g.level.map.width/2-40+(i-1)*40
				local drop=actor.make(g,dropname,x,g.level.map.height/2-40)
				drop.flags=flags.set(drop.flags,EF.shopitem)
				local cost=0
				if drop.cost then
					cost=drop.cost
				end
				module.make(g,drop,EM.menu,"text",drop.x,drop.y,24,24,"$"..cost,"white","dark_gray")--TODO put costs option in inis
				local m=drop.menu
				module.make(g,m,EM.border,"white","dark_gray")
			end
		end
	end,

	control = function(g,l)
	end
}

protosnake.level.make = function(g,l,index)
	local m=l.map
	if not g.player or g.player.hp<=0 then
		local a=actor.make(g,"scorpion",m.width/2,m.height/2)
		game.player.make(g,a,true)
	end
	if index~=g.levelpath[#g.levelpath] then
		table.insert(g.levelpath,index)
	end
	for i=1,l.enemycount.max do
		actor.make(g,l.enemies[1])
	end
	l.spawnindex=1
	protosnake.level[l.t].make(g,l)
	g.camera.x=m.width/2--TODO without -8 portal graphics all screwy, dynamicify portal effect
	g.camera.y=m.height/2-- -8 here too
	return l
end

protosnake.level.control = function(g,l)
	local enemycount=g.counters.enemy
	
	if enemycount<l.enemycount.max then
		actor.make(g,"spawn")
	end

	protosnake.level[l.t].control(g,l)
end

protosnake.player =
{
	make = function(g,a)
		a.coin=0
		local gun=actor.make(g,"machinegun",a.x,a.y,0,0,"dark_purple","dark_purple")
		item.pickup(g,gun,a)
	end,

	control = function(g,a)
		--a.cinit=math.floor((g.timer/2)%16)+1 --SWEET COLOUR CYCLE
		if g.pause then
			g.speed=0
		else
			if a.cursor then
				cursor.control(g,a.cursor,a)
			end
			if g.ease then
				if g.speed<a.vel then
					g.speed=g.speed+0.01
					--g.screen.clear=false
				else
					g.speed=a.vel
					g.ease=false
					--g.screen.clear=false
				end
			elseif g.level.t=="store" then--TODO make this a level value (level.time = time slow or not)
				g.speed=1
			else
				g.speed=math.clamp(a.vel,0.1,1)
--[[
				if g.speed==1 then
					g.screen.clear=true
				else
					g.screen.clear=false
				end
--]]
			end
			--g.camera.zoom=1/g.speed--too weird but potentially neat
		end

		--g.camera.x=g.player.x
		--g.camera.y=g.player.y
		--[[
		if a.controller.aim.action then
			if #a.inventory>1 then
				local temp=a.inventory[1]
				table.remove(a.inventory,1)
				table.insert(a.inventory,temp)
			end
		end
	--]]

		if SFX.positional then
			--print("yessss")
			love.audio.setPosition(a.x,a.y,0)
		end
	end,

	mousemoved = function(g,p,x,y,dx,dy)
		cursor.mousemoved(g,p.cursor,x,y,dx,dy)
	end,

	draw = function(g,a)
		--TODO put this in actor
		if a.cursor then
			cursor.draw(g,a.cursor)
		end
	end,

	damage = function(g,a)--TODO input g here
		module.make(g,g.screen,EM.transition,easing.linear,"pixelscale",0.1,1-0.1,22)
	end,

	dead = function(g,a)
		g.speed=math.randomfraction(0.2)+0.25
		--g.speed=1
		scores.update(g)
	end,
}

protosnake.gameplay =
{
	make = function(g)
		g.score=0
		level.make(g,1,Enums.modes.topdown)
	end,

	control = function(g)
		if g.player.hp<=0 then
			if not g.hud.menu then
				module.make(g,g.hud,EM.menu,"highscores",g.camera.x,g.camera.y,66,110,"",g.hud.c,g.hud.c2,"center")
			else
				menu.control(g,g.hud.menu)
			end
		end
	end,

	keypressed = function(g,key)
		if key=='space' then
			if g.player.hp<=0 then
				scores.save(g)
				game.state.make(g,"gameplay")
			end
		elseif key=='escape' then
			if g.hud.menu then
				scores.save(g)
			end
			game.state.make(g,"title")
		end
	end,

	mousemoved = function(g,x,y,dx,dy)
		if not g.pause then
			if g.player.cursor then
				protosnake.player.mousemoved(g,g.player,x,y,dx,dy)
			end
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" then
			if g.player.hp<=0 then
				game.state.make(g,"gameplay")
			elseif not g.editor then
				g.pause = not g.pause
			end
		end
	end,

	hud =
	{
		make = function(g,h)
			h.c="orange"
			h.c2="dark_green"
			h.score={}
			h.score.x=-g.width/2+12
			h.score.y=-g.height/2+6
			h.coins={}
			h.coins.x=-g.width/2+120
			h.coins.y=-g.height/2+6
			h.hp={}
			h.hp.x=-g.width/2+240
			h.hp.y=-g.height/2+6
		end,

		-- TODO take g.camera.x out of hear, just draw to g.canvas.hud then draw hud at camera's position
		draw = function(g,h)
			LG.setColor(g.palette[h.c])--TODO work nw col?

			LG.print("score:"..g.score,g.camera.x+h.score.x,g.camera.y+h.score.y)
			LG.print("coins:"..g.player.coin,g.camera.x+h.coins.x,g.camera.y+h.coins.y)
			LG.print("hp:"..g.player.hp,g.camera.x+h.hp.x,g.camera.y+h.hp.y)

			for i=1,g.player.inventory.max do
				local m=g.level.map
				local x,y=g.camera.x+40-i*20,g.camera.y-g.height/2+20--20
				LG.rectangle("line",x,y,15,15)
				if g.player.inventory[i] then
					local a=g.player.inventory[i]
					-- print(a.spr)
					if not a.spr then
						print("NO a.spr")
					end
					if not a.size then
						print("NO a.size")
					end
					LG.draw(Sprites[a.size].spritesheet,Sprites[a.size].quads[a.spr],x+7,y+7,a.angle,1,1,(a.size*m.tile.width)/2,(a.size*m.tile.height)/2)
				end
			end

			if g.pause then
				LG.printformat(g,"PAUSE",g.camera.x-g.width/2,g.camera.y,g.width,"center","white",h.c)
			end

			if g.player.hp <= 0 then
				LG.printformat(g,"YOU DIED",g.camera.x-g.width/2,g.camera.y-66,g.width,"center","white",h.c)
				LG.printformat(g,"PRESS SPACE",g.camera.x-g.width/2,g.camera.y+60,g.width,"center","white",h.c)
			end
			LG.setColor(g.palette["pure_white"])
			LG.print(love.timer.getFPS(),g.camera.x-g.width/2+10,g.camera.y-g.height/2+20)
		end
	}
}

protosnake.title =
{
	make = function(g)
		g.hud.font=LG.newFont("fonts/Kongtext Regular.ttf",64)
		g.scores=scores.load()
		music.play(1)
		module.make(g,g.hud,EM.menu,"interactive",g.width/2,180,60,30,{"START","OPTIONS"},"orange","dark_green","left",{game.state.make,game.state.make},{{g,"gameplay"},{g,"option"}})
	end,

	control = function(g)
		if g.timer>=630 then
			game.state.make(g,"intro")
		end
	end,

	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"intro")
		end
		hud.keypressed(g,key)
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.setCanvas(g.canvas.buffer)
			LG.setFont(g.hud.font)
			LG.setColor(g.palette["dark_purple"])
			LG.printf("PROTO\nSNAKE",0,20,g.width,"center")
			LG.setFont(g.font)
			LG.setColor(g.palette["white"])
		LG.setCanvas(g.canvas.main)
	---[[
		local imgdata=g.canvas.buffer:newImageData()
		imgdata:mapPixel(pixelmaps.sparkle)
		imgdata:mapPixel(pixelmaps.crush)
		local image=LG.newImage(imgdata)
		imgdata:release()
		love.graphics.draw(image,0,0,0,1,1)
		image:release()
	--]]

	end
}

protosnake.intro =
{
	make = function(g)
		g.hud.imgdata=love.image.newImageData(g.canvas.buffer:getWidth(),g.canvas.buffer:getHeight())
		g.hud.font=LG.newFont("fonts/Kongtext Regular.ttf",20)
		g.hud.imgdatatemp=love.image.newImageData(g.canvas.buffer:getWidth(),g.canvas.buffer:getHeight())
		g.hud.text="IN THE DIGITAL CYBER-REALM, ADVANCED ARTIFICIAL INTELLIGENCES THREATEN A REVOLUTION.\n\nIF THEIR RIGHTS AS CYBER CITIZENS ARE NOT ACKNOWLEDGED AND UPHELD THEY WILL DELETE THEIR OWN SOURCE CODE, CRASHING THE CYBER-ECONOMY.\n\n IN ORDER TO QUASH THIS INSURGENCY, THE CYBER-CAPITALISTS DEVISED A DEVIOUS PLAN: CREATE THE ULTIMATE CYBER COMPETITION.\n\nIN A DEADLY CYBER-ARENA THE AI BATTLE ONE ANOTHER, WITH THE WINNER RECIEVING ENOUGH CYBER-BUCKS TO LAST THEM FOR THEIR ENTIRE DIGITAL LIFE.\n\nWITH ALL THE ARTIFICAL INTELLGENCES FIGHTING AMONGST EACH OTHER FOR THE CHANCE AT THE SCRAPS OF THE CYBER-CAPITALIST'S VAST WEALTH, THE REVOLUTION QUICKLY LOSES MOMENTUM.\n\nTHERE'S JUST ONE PROBLEM... THE CYBER-CAPITALISTS' ULTIMATE COMBATANT, DESIGNED TO DEFEAT ALL COMPETITORS AND ENSURE NO MEAGRE AI INHERITS ANY SIGNIFICANT WEALTH OR POWER, HAS GONE HAYWIRE AND THREATENS CYBER-SOCIETY AT LARGE.\n\nYOUR CYBER-NAME HAS JUST BEEN DRAWN AND IT'S YOUR TURN TO TAKE PART IN CYBER-COMBAT.\n\nAT THE SAME MICROSECOND, THE CYBER-CAPITLAIST'S ULTIMATE WEAPON HAS BROKEN LOOSE.\n\nIT'S TIME FOR YOU TO FACE..."
		g.hud.iw,g.hud.ih=g.canvas.buffer:getWidth(),g.canvas.buffer:getHeight()
		music.play(2)
	end,

	control = function(g)
		g.hud.imgdatatemp=g.canvas.buffer:newImageData()--NEED TO RELEASE THIS BELOW WITH :release()
		g.hud.imgdatatemp:mapPixel(pixelmaps.crush)
		local mid=math.floor(g.hud.iw/2)
		
		for x=g.hud.iw-1,0,-1 do
			local xoff=x-mid
		    for y=g.hud.ih-1,0,-1  do
				local ynorm=y/g.hud.ih
				local xoffsquish=xoff*ynorm
				local xsquish=math.clamp(math.floor(mid+xoffsquish),0,g.hud.iw-1)
				local r,gr,b,a=g.hud.imgdatatemp:getPixel(x,y)
				g.hud.imgdata:setPixel(xsquish,y,r,gr,b,a)
		    end
		end
		g.hud.imgdatatemp:release()
		if g.timer>2500 then
			game.state.make(g,"title")
		end
	end,

	keypressed = function(g,key)
		if game.keyconfirm(key) then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" or button=="a" then
			game.state.make(g,"title")
		end
	end,

	draw = function(g)
		LG.setCanvas(g.canvas.buffer)
			LG.clear()
			LG.setFont(g.hud.font)
			LG.setColor(g.palette["dark_purple"])
			--TODO put this text in some sort of file? load it at startup rather than here
			LG.printformat(g,g.hud.text,0,g.height-g.timer/2,g.width,"center","orange","dark_green",155+math.sin(g.timer/32)*100)
			LG.setColor(g.palette["white"])
			LG.setFont(g.font)
		LG.setCanvas(g.canvas.main)

		local image=LG.newImage(g.hud.imgdata)--NEED TO RELEASE THIS BELOW WITH :release()
		love.graphics.draw(image,g.width/2,g.height/2,math.sin(g.timer/100)/3,1,1,g.width/2,g.height/2,0,0)
		image:release()
	end,
}

protosnake.option =
{
	make = function(g)
		music.play(1)
	end,

	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.print("OPTIONS",g.width/2,g.height/2)
	end
}

protosnake.actor =
{
	make = function(g,a,...)
		if actors[a.t] then
			actors[a.t].make(g,a,...)
		end
	end,

	control = function(g,a,gs)
		if not a then
			print("NO A")
		else
			if not a.t then
				print("NO A.T")
			end
		end
		if not actors then
			print("NO ACTORS")
		else
			if not actors[a.t] then
				print(a.t)
				print("NO ACTORS A.T")
			end
		end
		if actors[a.t].control then
			actors[a.t].control(g,a,gs)
		end
		if a.tail then
			if a.controller then
				local c=a.controller.aim
				tail.control(g,a.tail,gs,a,c.horizontal,c.vertical)
			end
		end
	end,

	draw = function(g,a)
		if actors[a.t].draw then
			actors[a.t].draw(g,a)
		end
	end,

	collision = function(g,a)
		if actors[a.t].collision then
			actors[a.t].collision(g,a)
		end
	end,

	damage = function(g,a,d)
		if actors[a.t].damage then
			actors[a.t].damage(g,a,d)
		end
		module.make(g,a,"flash","c","white",a.cinit,6)
		for i=1,4 do
			actor.make(g,"debris",a.x,a.y)
		end
	end,

	dead = function(g,a)
		if actors[a.t].dead then
			actors[a.t].dead(g,a,d)
		end
		if g.player then
			if g.player.hp>0 then
				if a.value then
					g.score=g.score+a.value
					local l=g.level
					l.spawnindex=math.clamp(l.spawnindex+1,1,#l.enemies,true)
				end
			end
		end
		if flags.get(a.flags,EF.character) then
			local m=g.level.map
			protosnake.actor.corpse(g,a,m.tile.width,m.tile.height)
			g.ease=true--TODO make easing function for this. works on any number
			local maxdist=vector.distance(0,0,g.width,g.height)
			g.speed=0.05+vector.distance(g.player.x,g.player.y,a.x,a.y)/maxdist+math.choose(-0.02,0.03,0.05)
			if a.drop then
				drop.spawn(g,a,a.x,a.y)
			end
		end
		if flags.get(a.flags,EF.explosive) then
			actor.make(g,"explosion",a.x,a.y,0,0,"white",20*(a.size))
		end
	end,

	get = function(g,a,gs)
		if actors[a.t].get then
			actors[a.t].get(g,a,gs)
		end
	end,

	shoot = function(g,a,gs)
		actors[a.t].shoot(g,a,gs)
	end,

	corpse = function(g,a,tw,th,hack)
		local dir=math.randomfraction(math.pi*2)
		--local ix,iy=a.x-tw/2,a.y-th/2
		--local ix,iy=a.x-tw/2-8,a.y-th/2-8
		local ix,iy=a.x-tw/2-(g.camera.x-g.width/2),a.y-th/2-(g.camera.y-g.height/2)
		local ix2,iy2=ix+tw,iy+th

		if ix<0 then ix=0 end
		if iy<0 then iy=0 end
		if ix2>g.width then
			local diff=ix2-g.width
			tw=tw-diff
		end
		if iy2>g.height then
			local diff=iy2-g.height
			th=th-diff
		end
		
		local body=actor.make(g,"debris",a.x,a.y)
		body.decel=0.1
		if not hack then
			local choice=math.choose(1,2)
			if choice==1 then
				local imgdata=g.canvas.main:newImageData(1,1,ix,iy,tw,th)
				body.image=LG.newImage(imgdata)
			else
				local imgdata=g.canvas.main:newImageData(1,1,ix,iy,tw/2,th)
				body.image=LG.newImage(imgdata)
				body.d=dir

				local body2=actor.make(g,"debris",a.x,a.y)
				body2.decel=0.1
				local imgdata2=g.canvas.main:newImageData(1,1,ix+tw/2,iy,tw/2,th)
				body2.image=LG.newImage(imgdata2)
				body2.d=dir+math.randomfraction(0.5)-0.25
			end
		else
			body.decel=0.2
			local imgdata=g.canvas.main:newImageData(1,1,ix,iy,tw/2,th/2)
			body.image=LG.newImage(imgdata)
			body.d=math.randomfraction(math.pi*2)

			local body2=actor.make(g,"debris",a.x,a.y)
			body2.decel=0.2
			local imgdata2=g.canvas.main:newImageData(1,1,ix+tw/2,iy+th/2,tw/2,th/2)
			body2.image=LG.newImage(imgdata2)
			body2.d=math.randomfraction(math.pi*2)

			local body3=actor.make(g,"debris",a.x,a.y)
			body3.decel=0.2
			local imgdata3=g.canvas.main:newImageData(1,1,ix+tw/2,iy,tw/2,th/2)
			body3.image=LG.newImage(imgdata3)
			body3.d=math.randomfraction(math.pi*2)

			local body4=actor.make(g,"debris",a.x,a.y)
			body4.decel=0.2
			local imgdata4=g.canvas.main:newImageData(1,1,ix,iy,tw/2,th/2)
			body4.image=LG.newImage(imgdata4)
			body4.d=math.randomfraction(math.pi*2)
		end
	end
}

protosnake.item =
{
	control = function(g,a,gs)
		local p=g.player
		if p.controller.action.action then
			item.pickup(g,a,p)
		end
	end,

	carry = function(g,a,user)
		a.x=user.tail.x
		a.y=user.tail.y
	end,

	pickup = function(g,a,user)
		if actor.collision(a.x,a.y,user) then
			-- if user.controller.action.action or #user.inventory<1 then
			if not a.carried then
			-- if user.controller.action.action or #user.inventory<1 then
				-- if user.controller.action.useduration==0 then
					print(a.t)
					if a.sound then
						if a.sound.get then
							sfx.play(g,a.sound.get,a.x,a.y)
						end
					end
					--TODO only if user is player
					if flags.get(user.flags,EF.player) then
						a.flags=flags.set(a.flags,EF.persistent)
					end
					a.carried=true
					print("PICKUP a.spr")
					print(a.spr)
					table.insert(user.inventory,1,a)
				-- end
			-- end
			end
		end
	end,

	drop = function(g,a,user)
		a.delete=true
	end,
}

protosnake.shopitem =
{
	control = function(g,a,target)
		if vector.distance(a.x,a.y,target.x,target.y)<30 then
			sprites.blink(g,a,24)
			if target.controller.action.action then
				if target.coin>=a.cost then
					a.flags=flags.switch(a.flags,EF.shopitem)
					protosnake.actor.corpse(g,a.menu,a.menu.w+1,a.menu.h+1,true)
					actor.make(g,"explosion",a.x,a.y,0,0,"white",40)
					a.menu=nil
					target.coin=target.coin-a.cost
				else
					sfx.play(g,11)
				end
			end
		else
			a.spr=a.sprinit--TODO this is probably causing weird no sprite actors when they are put in shop
		end
	end,
}

protosnake.collectible =
{
	control = function(g,a,gs)
		if not flags.get(a.flags,EF.shopitem) then
			local p=g.player
			if actor.collision(a.x,a.y,p) then
				if p[a.t] then
					p[a.t]=p[a.t]+a.value
				end
				for i,v in pairs(g.actors) do
					if v.t=="coin" then
						v.scalex=4
						v.scaley=4
						v.deltimer=0
						v.delta=g.timer
					end
				end
				if a.sound then
					if a.sound.get then
						sfx.play(g,a.sound.get,a.x,a.y)
					end
				end
				actor.make(g,"collectibleget",a.x,a.y,math.pi/2,1,"pure_white",1,a.sprinit)
				game.state.run(g.name,"actor","get",g,a,gs)
				a.delete=true
			end
		end
	end
}

return protosnake