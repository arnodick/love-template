local function make(a,c)
	a.c=c or Enums.colours.orange
	a.d=math.randomfraction(math.pi*2)
	a.vel=love.math.random(3,4)
	a.decel=0.05
end

local function control(a)
	if a.vel<0 then
		a.delete=true
	end
end

local function draw(a)
	love.graphics.points(a.x,a.y)
end

local function collision(a,collx,colly)
	if collx then
		a.vec[1]=-a.vec[1]
		a.d=vector.direction(a.vec[1],a.vec[2])
	end
	if colly then
		a.vec[2]=-a.vec[2]
		a.d=vector.direction(a.vec[1],a.vec[2])
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
	collision = collision,
}