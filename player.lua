local function make(a)
	controller.make(a,Enums.controltypes.gamepad)
end

local function control(a)
	a.x = a.x + a.controller[Enums.buttons.horizontal]
	a.y = a.y + a.controller[Enums.buttons.vertical]
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