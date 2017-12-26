local function make(g,a,c,size,spr,hp)
	local e=Enums

	if #Joysticks>0 then
		module.make(a,EM.controller,EMC.move,EMCI.gamepad)
		module.make(a,EM.controller,EMC.aim,EMCI.gamepad)
		module.make(a,EM.controller,EMC.action,EMCI.gamepad)
	else
		module.make(a,EM.controller,EMC.move,EMCI.keyboard)
		module.make(a,EM.controller,EMC.aim,EMCI.mouse)
		module.make(a,EM.controller,EMC.action,EMCI.mouse)

		module.make(a,EM.cursor)
	end

	a.cinit=c or EC.dark_blue
	a.c=a.cinit or EC.blue
	a.size=size or 1
	a.spr=spr or 81
	a.hp=hp or 8

	a.coin=0

	module.make(a,EM.sound,4,"damage")
	module.make(a,EM.animation,EM.animations.frames,10,2)
	module.make(a,EM.hitradius,4)
	module.make(a,EM.tail,a.cinit,9)
	module.make(a,EM.inventory,2)
	actor.make(g,EA[g.name].machinegun,a.x,a.y,0,0,EC.dark_purple,EC.dark_purple)
	a.flags=flags.set(a.flags,EF.character,EF.persistent,EF.damageable, EF.shootable, EF.explosive)
	--print(EF.shootable)

	--animation.make(a,2,32) --SWEET GLITCH ANIMATION
end

local function control(g,a)
	--a.cinit=math.floor((g.timer/2)%16)+1 --SWEET COLOUR CYCLE
	local gamename=g.name
	if g.pause then
		g.speed=0
	else
		if g.ease then
			if g.speed<a.vel then
				g.speed=g.speed+0.01
			else
				g.speed=a.vel
				g.ease=false
			end
		elseif g.level.t=="store" then--TODO make this a level value (level.time = time slow or not)
			g.speed=1
		else
			g.speed=math.clamp(a.vel,0.1,1)
		end
	end
	--[[
	if a.controller.aim.action then
		if #a.inventory>1 then
			local temp=a.inventory[1]
			table.remove(a.inventory,1)
			table.insert(a.inventory,temp)
		end
	end
	--]]
	if a.cursor then
		cursor.update(a.cursor)
	end
	--if a.controller.action then	
	--end
	if SFX.positonal then
		love.audio.setPosition(a.x,a.y,0)
	end
end

local function draw(g,a)
	if a.cursor then
		cursor.draw(a.cursor)
	end
end

local function damage(a)
	module.make(Game.screen,EM.transition,easing.linear,"pixelscale",0.1,1-0.1,22)
end

local function dead(a)
	Game.speed=math.randomfraction(0.2)+0.25
	--Game.speed=1
	scores.save()
end

return
{
	make = make,
	control = control,
	draw = draw,
	damage = damage,
	dead = dead,
}