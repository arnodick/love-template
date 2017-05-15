local function make(m,r)
	m.r=r
end

local function draw(a)
	LG.circle("line",a.x,a.y,a.hitradius.r)
end

return
{
	make = make,
	draw = draw,
}