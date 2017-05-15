local function make(m,x,y,w,h)
	m.x=x
	m.y=y
	m.w=w
	m.h=h
end

local function draw(a)
	LG.rectangle("line",a.x+a.hitbox.x,a.y+a.hitbox.y,a.hitbox.w,a.hitbox.h)
end

return
{
	make = make,
	draw = draw,
}