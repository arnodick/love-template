local function make(a)
	a.hit=0
	a.hitsfx=3
	a.hittime=6
	a.hitcolour=7
	gun.make(a,1,-0.79,9,0.012,-math.pi,0,Enums.colours.green)
	animation.make(a,10,2)
end

local function control(a)
	
end

local function hitground(a)

end

local function draw(a)
	--love.graphics.points(a.x,a.y)
end

return
{
	make = make,
	control = control,
	hitground = hitground,
	draw = draw,
}