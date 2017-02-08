local function make(a,t,angle,len,speed,anglemin,anglemax,bc)
	a.gun={}
	a.gun.t=t
	a.gun.angle=angle
	a.gun.leninit=len
	a.gun.len=len
	a.gun.speed=speed
	a.gun.anglemin=anglemin
	a.gun.anglemax=anglemax
	a.gun.bc=bc
	a.gun.c=a.cinit
	a.gun.x=0
	a.gun.y=0
	a.gun.xs=0
	a.gun.ys=0
	a.gun.vec={0,0}
	a.gun.delta=0
end

local function control(g,gs,a,vx,vy,shoot)
	local e=Enums
	g.angle=vector.direction(vx,vy)
	g.vec[1]=math.cos(g.angle)
	g.vec[2]=math.sin(g.angle)

	if g.len<g.leninit then
		g.len = g.len + gs
	end
	local hack=0
	if g.angle < -1.4 then
		hack=1 --NOTE: this is because the line wasn't drawing rom the proper origin because of... Math?
	end

	g.xs=a.x+hack
	g.ys=a.y
	g.x=a.x+g.vec[1]*g.len
	g.y=a.y+g.vec[2]*g.len

	--TODO dynamicalize this
	if g.delta<=0 then
		if shoot then
			local guntype=Guntypes[g.t]
			sfx.play(guntype.snd)
			--g.len=1
			--gun specific controls
			if guntype.proj==4 or guntype.proj==5 then
				--lazer
				local dist=100
				actor.make(Enums.actors.projectile,guntype.proj,g.x+g.vec[1]*dist,g.y+g.vec[2]*dist,Enums.colours.pure_white,g.angle,0,a.t,g.x,g.y,g.angle)
			else
				local bvel=guntype.vel
				for b=1,guntype.num do
					local rand = love.math.random(-guntype.acc/2*100,guntype.acc/2*100)/50*math.pi
					actor.make(Enums.actors.projectile,guntype.proj,g.x,g.y,g.bc,-g.angle+rand,bvel+math.randomfraction(0.5),a.t)
				end
				if g.angle>-0.5*math.pi then
					g.angle = g.angle - guntype.rec*math.pi--*2
				end
			end
			actor.make(e.actors.effect,e.effects.cloud,g.x,g.y,e.colours.dark_gray,-g.angle+math.randomfraction(1)-0.5,math.randomfraction(1),6)
			g.delta=guntype.rof
		end
	else 
		g.delta = g.delta - 1*gs
		if g.delta>20 then
			if math.floor(Timer)%3==0 then
				actor.make(Enums.actors.effect,Enums.effects.cloud,g.x,g.y+love.math.random(-3,3))
			end
		end
	end
end

local function draw(g)
	love.graphics.setColor(Palette[g.c])
	love.graphics.line(g.xs,g.ys,g.x,g.y)
end

return
{
	make = make,
	control = control,
	draw = draw,

}