local function make(g,gc,bc,shopitem,...)
	local ea=Enums.actors
	local ea=Enums.colours
	g.c=gc
	g.bc=bc
	g.leninit=len or 9
	g.len=g.leninit
	g.anglemin=-math.pi
	g.anglemax=0
	g.angle=-0.79
	g.mx=g.x-math.cos(g.angle+0.1)*g.len/2
	g.my=g.y-math.sin(g.angle+0.1)*g.len/2
	g.tx=g.x-math.cos(g.angle)*g.len
	g.ty=g.y-math.sin(g.angle)*g.len
	g.getsfx=10
	g.delta=0--NOTE need this bc actor.make sets delta to Timer, so any actor not spawning at Timer==0 can't shoot
	if shopitem then
		g.flags=flags.set(g.flags,Enums.flags.shopitem)
	end
	if _G[ea.items[g.st]]["make"] then
		_G[ea.items[g.st]]["make"](g)
	end
	return g
end

local function control(a,gs)
	local e=Enums
	if #Player.inv<1 then
		if actor.collision(a.x,a.y,Player) then	
			if a.getsfx then
				sfx.play(a.getsfx)
			end
			table.insert(Player.inv,a)
		end
	end
	if _G[e.actors.items[a.st]]["control"] then
		_G[e.actors.items[a.st]]["control"](a,gs)
	end
end

local function use(g,gs,a,vx,vy,shoot)
	local e=Enums
	g.angle=vector.direction(vx,vy)
	g.vec[1]=math.cos(g.angle)
	g.vec[2]=math.sin(g.angle)

	g.x=a.x+g.vec[1]*g.len
	g.y=a.y+g.vec[2]*g.len

	if g.delta<=0 then
		if shoot then
			sfx.play(g.snd,g.x,g.y)

			if _G[e.actors.items[g.st]]["shoot"] then
				_G[e.actors.items[g.st]]["shoot"](g,gs)
			end

			actor.make(e.actors.effect,e.actors.effects.cloud,g.x,g.y,-g.angle+math.randomfraction(1)-0.5,math.randomfraction(1))
			g.delta=g.rof
		end
	else 
		g.delta = g.delta - 1*gs
	end
end

local function draw(g)

end

return
{
	make = make,
	control = control,
	use = use,
	draw = draw,
}