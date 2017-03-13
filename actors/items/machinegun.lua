local function make(g)
	g.size=1
	g.sprinit=161
	g.spr=g.sprinit
	g.projvel=1.5
	g.rof=4
	g.num=1
	g.acc=0.015
	g.snd=2
	g.proj=Enums.actors.projectiles.bullet
end

local function draw(g)

end

local function shoot(g)
	for b=1,g.num do
		local rand = love.math.random(-g.acc/2*100,g.acc/2*100)/50*math.pi
		actor.make(Enums.actors.projectile,g.proj,g.x,g.y,-g.angle+rand,g.projvel+math.randomfraction(0.5),g.bc)
	end
end

return
{
	make = make,
	draw = draw,
	shoot = shoot,
}