local function make(g)
	g.vel=1.5
	g.rof=4
	g.num=1
	g.acc=0.015
	g.snd=2
	g.proj=1
end

local function draw(g)

end

local function shoot(g)
	for b=1,g.num do
		local rand = love.math.random(-g.acc/2*100,g.acc/2*100)/50*math.pi
		actor.make(Enums.actors.projectile,g.proj,g.x,g.y,g.bc,-g.angle+rand,g.vel+math.randomfraction(0.5))
	end
end

return
{
	make = make,
	draw = draw,
	shoot = shoot,
}