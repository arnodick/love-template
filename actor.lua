local function make(t,x,y,d,vel,...)
	local a={}
	a.t=t
	a.x=x or love.math.random(319)
	a.y=y or love.math.random(239)
	a.d=d or 0
	a.vel=vel or 0
	a.vec={math.cos(a.d),math.sin(a.d)}
	a.angle=0
	a.speed=1
	a.delta=Game.timer
	a.delete=false
	a.flags = 0x0
	if _G[EA[Game.name][a.t]]["make"] then
		_G[EA[Game.name][a.t]]["make"](a,...)
	end
	counters.update(Game,Game.counters,a,1)
--[[
	if flags.get(a.flags,EF.queue) then
		Game.actors[ EA[Game.name ][a.t].."s" ][ EA[Game.name ][a.t].."s" ]={}
	end
--]]
	table.insert(Game.actors,a)
	return a
end

local function control(g,a,gs)
	controller.update(a,gs)
	
	--game mode's specific type control (ie topdown.control)
	if _G[g.state.modename]["control"] then
		_G[g.state.modename]["control"](a,gs)
	end

	--actor's specific type control (ie snake.control)
	if _G[EA[g.name][a.t]]["control"] then
		_G[EA[g.name][a.t]]["control"](a,gs)
	end

	if a.item then--if a IS an item, do its item stuff
		item.control(a,gs)
	end

	if a.collectible then--if a IS a collectible, do its collectible stuff
		collectible.control(a,gs)
	end

	if a.anglespeed then--TODO make angle module with speed and accel
		if a.anglespeeddecel then
			a.anglespeed=math.snap(a.anglespeed,a.anglespeeddecel,0)
		end
		a.angle = a.angle + a.anglespeed*a.vec[1]*math.pi*2*gs
	end

	if a.hit then
		hit.control(a.hit,a,gs)
	end

	if a.flash then
		flash.control(a,a.flash)
	end

	if a.decel then--TODO make decel module with speed OR velocity module? w speed and accel
		a.vel=math.snap(a.vel,a.decel*(g.timer-a.delta)/4*gs,0)
		--a.vel=math.snap(a.vel,a.decel*gs,0)
--[[
		if not a.transition then
			module.make(a,EM.transition,easing.linear,"vel",a.vel,-a.vel,30)
		else
			transition.control(a,a.transition)
		end
--]]
	end

	if flags.get(a.flags,EF.shopitem) then
		shopitem.control(a,g.player)
	end

	if a.inventory then
		inventory.control(a,a.inventory)
	end

---[[
	if a.tail then
		if a.controller then
			local c=a.controller.aim
			tail.control(a.tail,gs,a,c.horizontal,c.vertical)
		end
	end
--]]

	if a.x<-10--TODO make these limits dynamic or something
	or a.x>330
	or a.y>250
	or a.y<-10 then
		if not flags.get(a.flags,EF.persistent) then
			a.delete=true
	 	end
	end
end

local function draw(a)
	if a.menu then
		menu.draw(a.menu)
	end

	if _G[Game.state.modename]["draw"] then
		_G[Game.state.modename]["draw"](a)
	end
end

local function damage(a,d)
	local g=Game
	if not a.delete then
		module.make(a,EM.flash,"c",EC.white,a.cinit,6)
		if a.sound then
			if a.sound.damage then
				sfx.play(a.sound.damage,a.x,a.y)
			end
		end

		if flags.get(a.flags,EF.damageable) then
			a.hp = a.hp - d
			if _G[EA[g.name][a.t]]["damage"] then
				_G[EA[g.name][a.t]]["damage"](a)
			end
			for i=1,4 do
				actor.make(EA[g.name].debris,a.x,a.y)
			end

			if a.hit then
				hit.damage(a.hit,a)
			end

			if a.hp<1 then
				--sfx.play(a.deathsnd,a.x,a.y)
				a.delete=true

				if g.player.hp>0 then
					if a.value then
						g.score=g.score+a.value
						local l=g.levels.current
						l.spawnindex=math.clamp(l.spawnindex+1,1,#l.enemies,true)
					end
				end

				if flags.get(a.flags,EF.explosive) then
					actor.make(EA[g.name].explosion,a.x,a.y,0,0,EC.white,20*(a.size))
				end

				if flags.get(a.flags,EF.character) then
					character.dead(a)
				end
				if _G[EA[g.name][a.t]]["dead"] then
					_G[EA[g.name][a.t]]["dead"](a)
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

local function collision(x,y,enemy)--TODO something other than enemy here?
	local dist=vector.distance(enemy.x,enemy.y,x,y)
	if enemy.hitradius then
		return hitradius.collision(enemy.hitradius.r,dist)
	elseif enemy.hitbox then
		return hitbox.collision(x,y,enemy)
	end
	return false
end

local function corpse(a,tw,th,hack)
	local g=Game
	local dir=math.randomfraction(math.pi*2)
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
	
	local body=actor.make(EA[g.name].debris,a.x,a.y)
	body.decel=0.1
	if not hack then
		local choice=math.choose(1,2)
		if choice==1 then
			local imgdata=g.canvas.main:newImageData(ix,iy,tw,th)
			body.image=LG.newImage(imgdata)
		else
			local imgdata=g.canvas.main:newImageData(ix,iy,tw/2,th)
			body.image=LG.newImage(imgdata)
			body.d=dir

			local body2=actor.make(EA[g.name].debris,a.x,a.y)
			body2.decel=0.1
			local imgdata2=g.canvas.main:newImageData(ix+tw/2,iy,tw/2,th)
			body2.image=LG.newImage(imgdata2)
			body2.d=dir+math.randomfraction(0.5)-0.25
		end
	else
		body.decel=0.2
		local imgdata=g.canvas.main:newImageData(ix,iy,tw/2,th/2)
		body.image=LG.newImage(imgdata)
		body.d=math.randomfraction(math.pi*2)

		local body2=actor.make(EA[g.name].debris,a.x,a.y)
		body2.decel=0.2
		local imgdata2=g.canvas.main:newImageData(ix+tw/2,iy+th/2,tw/2,th/2)
		body2.image=LG.newImage(imgdata2)
		body2.d=math.randomfraction(math.pi*2)

		local body3=actor.make(EA[g.name].debris,a.x,a.y)
		body3.decel=0.2
		local imgdata3=g.canvas.main:newImageData(ix+tw/2,iy,tw/2,th/2)
		body3.image=LG.newImage(imgdata3)
		body3.d=math.randomfraction(math.pi*2)

		local body4=actor.make(EA[g.name].debris,a.x,a.y)
		body4.decel=0.2
		local imgdata4=g.canvas.main:newImageData(ix,iy,tw/2,th/2)
		body4.image=LG.newImage(imgdata4)
		body4.d=math.randomfraction(math.pi*2)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
	collision = collision,
	damage = damage,
	impulse = impulse,
	corpse = corpse,
}