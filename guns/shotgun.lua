local function make(g)
	g.vel=3
	g.rof=16
	g.num=20
	g.acc=0.1
	g.snd=5
	g.proj=Enums.actors.projectiles.bullet
end

local function draw(g)

end

local function shoot(g)
	for b=1,g.num do
		local rand = love.math.random(-g.acc/2*100,g.acc/2*100)/50*math.pi
		actor.make(Enums.actors.projectile,g.proj,g.x,g.y,-g.angle+rand,g.vel+math.randomfraction(0.5),g.bc)
	end
end

return
{
	make = make,
	draw = draw,
	shoot = shoot,
}