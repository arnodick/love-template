local function make(a,c,bc)
	a.c=c or EC.blue
	a.bc=bc
	a.size=1
	a.sprinit=161
	a.spr=a.sprinit
	a.projvel=1.5
	a.rof=4
	a.num=1
	a.acc=0.015
	a.snd=2
	a.proj=EA[Game.name].bullet
	module.make(a,EM.item)
end

local function draw(a)

end

local function shoot(a)
	for b=1,a.num do
		local rand = love.math.random(-a.acc/2*100,a.acc/2*100)/50*math.pi
		actor.make(Game,a.proj,a.x,a.y,-a.angle+rand,a.projvel+math.randomfraction(0.5),a.bc)
	end
end

return
{
	make = make,
	draw = draw,
	shoot = shoot,
}