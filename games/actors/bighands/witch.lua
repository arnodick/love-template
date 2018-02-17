local function make(g,a,c,size,spr,hp)
	local e=Enums

	a.size=size or 1
	a.spr=spr or 193
	a.hp=hp or 8

	module.make(a,EM.sound,4,"damage")
	module.make(a,EM.hitradius,4)
	module.make(a,EM.inventory,1)

	a.flags=flags.set(a.flags,EF.character,EF.persistent,EF.damageable)
end

local function control(g,a)
	a.hand.x=a.x+(math.cos(a.angle+a.hand.d)*a.hand.l)
	a.hand.y=a.y+(math.sin(a.angle+a.hand.d)*a.hand.l)
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
					module.make(a,EM.transition,easing.linear,"angle",a.angle,-controllerdifference,math.abs(controllerdifference*5))
				end
			end
		end
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
end


return
{
	make = make,
	control = control,
}