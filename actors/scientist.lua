local function make(a)
	gun.make(a,1,-0.79,7,0.012,-math.pi,0)
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