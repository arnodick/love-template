local function make(a)
	controller.make(a,Enums.controltypes.gamepad)
	gun.make(a,-0.79,7,0.012,-math.pi,0)
end

local function control(a)
	a.x = a.x + a.controller[Enums.buttons.leftstickhorizontal][1]
	a.y = a.y + a.controller[Enums.buttons.leftstickvertical][1]
end

local function hitground(a)

end

local function draw(a)
	love.graphics.setColor(Palette[a.c])
	love.graphics.points(a.x,a.y)
end

return
{
	make = make,
	control = control,
	hitground = hitground,
	draw = draw,
}