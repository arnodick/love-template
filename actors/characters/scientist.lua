local function make(a)
	local c=Enums.colours.green
	if a.ct==Enums.controllers.gamepad then
		c=Enums.colours.dark_purple
	end
	gun.make(a,1,-0.79,9,0.012,-math.pi,0,c)
	animation.make(a,10,2)
	a.move=math.choose(-1,1)
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