local function make(g,a,c,size,spr,hp)
	local e=Enums

	local playernum=#g.players+1
	--if #g.players+1 == 1 then
		if #Joysticks>0 then
			module.make(a,EM.controller,EMC.move,EMCI.gamepad,playernum)
			module.make(a,EM.controller,EMC.aim,EMCI.gamepad,playernum)
			module.make(a,EM.controller,EMC.action,EMCI.gamepad,playernum)
		end
--[[
	else
		module.make(a,EM.controller,EMC.move,EMCI.keyboard)
		module.make(a,EM.controller,EMC.aim,EMCI.mouse)
		module.make(a,EM.controller,EMC.action,EMCI.mouse)
	end
--]]

	--a.cinit=c or EC.pure_white
	--a.c=a.cinit or EC.pure_white
	a.size=size or 1
	a.spr=spr or 193
	a.hp=hp or 8

	module.make(a,EM.sound,4,"damage")
	module.make(a,EM.hitradius,4)
	module.make(a,EM.inventory,1)
	actor.make(g,EA[g.name].wand,a.x+20,a.y)

	a.hand={l=8,d=math.pi/4,x=0,y=0}
	a.hand.x=a.x+(math.cos(a.d+a.hand.d)*a.hand.l)
	a.hand.y=a.y+(math.sin(a.d+a.hand.d)*a.hand.l)

	a.flags=flags.set(a.flags,EF.character,EF.persistent,EF.damageable)
end

local function control(g,a)
	a.hand.x=a.x+(math.cos(a.angle+a.hand.d)*a.hand.l)
	a.hand.y=a.y+(math.sin(a.angle+a.hand.d)*a.hand.l)
	local c=a.controller.move
	if not a.controller.action.action then
		--a.vel=a.vel*2
---[[
		if not a.transition then
			if c then
				if c.horizontal~=0 or c.vertical~=0 then
					local controllerdirection=vector.direction(c.horizontal,-c.vertical)
					local controllerdifference=controllerdirection+a.angle
					local controllerdifference2=a.angle-(math.pi*2-controllerdirection)
					if math.abs(controllerdifference)>math.abs(controllerdifference2) then
						controllerdifference=controllerdifference2
					end
					module.make(a,EM.transition,easing.linear,"angle",a.angle,-controllerdifference,math.abs(controllerdifference*5))
					--module.make(a,EM.transition,easing.linear,"angle",a.angle,-controllerdifference,math.abs(controllerdifference*20))
				end
			end
		end
--]]
		--a.angle=-a.d
	else
		a.angle=vector.direction(a.controller.aim.horizontal,a.controller.aim.vertical)
		a.d=a.angle
	end
	if a.vel>0 then
		if not a.animation then
			module.make(a,EM.animation,EM.animations.frames,10,4)
		end
	else
		if a.animation then
			a.animation=nil
		end
	end
	g.camera.x=a.x
	g.camera.y=a.y
end

local function draw(g,a)
	--LG.points(a.hand.x,a.hand.y)
end

local function damage(a)
	
end

local function dead(a)
	
end

return
{
	make = make,
	control = control,
	draw = draw,
	damage = damage,
	dead = dead,
}