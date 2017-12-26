local function make(a,c,size,spr)
	a.cinit=c or EC.pure_white
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 113
	a.sprinit=a.spr

	module.make(a,EM.collectible)
	module.make(a,EM.sound,6,"get")

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
	a.alpha=255
	a.flags=flags.set(a.flags,EF.bouncy)
end

local function control(g,a,gs)
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
		local dist=vector.distance(a.x,a.y,g.player.x,g.player.y)
		if dist<30 then
			if not a.controller then
				module.make(a,EM.controller,EMC.move,EMCI.ai,g.player)
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
			sprites.blink(a,14)
		else
			sprites.blink(a,6)
		end
		if a.deltimer>=120 then
			if a.vel==0 then
				sfx.play(7)
				for i=1,20 do
					actor.make(g,EA[g.name].cloud,a.x,a.y,math.randomfraction(math.pi*2),math.randomfraction(1))
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