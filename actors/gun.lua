local function make(g,gc,bc,...)
	local ea=Enums.actors
	g.c=gc
	g.bc=bc
	g.leninit=len or 9
	g.len=g.leninit
	g.anglemin=-math.pi
	g.anglemax=0
	g.angle=-0.79
	g.mx=g.x-math.cos(g.angle+0.1)*g.len/2
	g.my=g.y-math.sin(g.angle+0.1)*g.len/2
	g.xs=0
	g.ys=0
	g.tx=g.x-math.cos(g.angle)*g.len
	g.ty=g.y-math.sin(g.angle)*g.len
	g.getsfx=10
--g.decel=0.1
	g.delta=0--NOTE need this bc actor.make sets delta to Timer, so any actor not spawning at Timer==0 can't shoot
	if _G[ea.guns[g.st]]["make"] then
		_G[ea.guns[g.st]]["make"](g)
	end
	return g
end

local function control(a,gs)
	if not Player.gun then
		if actor.collision(a.x,a.y,Player) then	
			if a.getsfx then
				sfx.play(a.getsfx)
			end
			Player.gun=a
		end
	end
end

local function use(g,gs,a,vx,vy,shoot)
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
	--g.mx=a.x+g.vec[1]*g.len/2
	--g.my=a.y+g.vec[2]*g.len/2
	g.mx=a.x+8
	if math.abs(g.angle)<1 then
		g.my=a.y
	elseif g.angle<0 then
		g.my=a.y-6-math.floor((Timer/a.anim.speed)%a.anim.frames)*4
	else
		g.my=a.y+8+math.floor((Timer/a.anim.speed)%a.anim.frames)*4
	end
	g.x=a.x+g.vec[1]*g.len
	g.y=a.y+g.vec[2]*g.len
	g.tx=a.x+4
	g.ty=a.y

	if g.delta<=0 then
		if shoot then
			sfx.play(g.snd,g.x,g.y)

			if _G[e.actors.guns[g.st]]["shoot"] then
				_G[e.actors.guns[g.st]]["shoot"](g,gs)
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
		--love.graphics.line(g.mx,g.my,g.x,g.y)
		--love.graphics.line(g.tx,g.ty,g.mx,g.my)
		local curve=love.math.newBezierCurve(g.tx,g.ty,g.mx,g.my,g.x,g.y)
		love.graphics.line(curve:render(2))
	end
end

return
{
	make = make,
	control = control,
	use = use,
	draw = draw,

}