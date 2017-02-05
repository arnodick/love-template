local function make(a)

end

local function control(a)

end

local function draw(a)
	love.graphics.line(a.x,a.y,a.tail[1],a.tail[2])
end


return
{
	make = make,
	control = control,
	draw = draw,
}