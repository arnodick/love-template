local function make(a,c,size,spr)
	a.cinit=c or Enums.colours.pure_white
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 113
	a.sprinit=a.spr

	a.d=math.randomfraction(math.pi*2)
	a.vel=math.randomfraction(4)+4
	a.decelinit=0.05
	a.decel=a.decelinit
	a.anglespeed=(a.vec[1]+math.choose(0,0,3,4))*(a.vel/60)
	a.anglespeeddecel=0.05
	a.deltimer=0
	a.getsfx=6
	a.follow=false
	a.value=1
	a.flags=flags.set(a.flags,Enums.flags.bouncy)
end

local function control(a,gs)
	local e=Enums
	if a.vel<=0 then
		a.follow=true
	end
	if a.follow then
		local dist=vector.distance(a.x,a.y,Player.x,Player.y)
		if dist<30 then
			local vx,vy=vector.components(a.x,a.y,Player.x,Player.y)
			vy=-vy
			a.d=vector.direction(vx,vy)
			a.vel=5/dist
		else
			a.decel=a.decelinit
		end
	end
	if Timer-a.delta>=120 then
		a.deltimer = a.deltimer+gs
		if a.deltimer<=80 then
			sprites.blink(a,14)
		else
			sprites.blink(a,6)
		end
		if a.deltimer>=120 then
			if a.vel==0 then
				sfx.play(7)
				for i=1,20 do
					actor.make(e.actors.effect,e.actors.effects.cloud,a.x,a.y,math.randomfraction(math.pi*2),math.randomfraction(1))
				end
				a.delete=true
			end
		end
	end
end

return
{
	make = make,
	control = control,
}