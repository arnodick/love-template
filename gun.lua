local function make(a,t,len,anglemin,anglemax,bc)
	local g={}
	g={}
	g.t=t
	g.leninit=len
	g.len=len
	g.anglemin=anglemin
	g.anglemax=anglemax
	g.bc=bc
	g.angle=-0.79
	g.c=a.cinit
	g.x=0
	g.y=0
	g.xs=0
	g.ys=0
	g.vec={0,0}
	g.delta=0
	if _G[Enums.guns[g.t]]["make"] then
		_G[Enums.guns[g.t]]["make"](g)
	end
	a.gun=g
	--TODO make gun first, THEN add it to character's weapon slot
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

	if g.delta<=0 then
		if shoot then
			sfx.play(g.snd,g.x,g.y)

			if _G[Enums.guns[g.t]]["shoot"] then
				_G[Enums.guns[g.t]]["shoot"](g,gs)
			end

			actor.make(e.actors.effect,e.actors.effects.cloud,g.x,g.y,-g.angle+math.randomfraction(1)-0.5,math.randomfraction(1))
			g.delta=g.rof
		end
	else 
		g.delta = g.delta - 1*gs
	end
end

local function draw(g)
	if g then
		love.graphics.setColor(Palette[g.c])
		love.graphics.line(g.xs,g.ys,g.x,g.y)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,

}