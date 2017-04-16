local function make(m,x,y,w,h,c1,c2)
	local b={}
	b.x=x
	b.y=y
	b.w=w
	b.h=h
	b.c1=c1
	b.c2=c2
	m.border=b
end

local function draw(border)
	local alpha=230

	local r,g,b=unpack(Game.palette[border.c2])
	LG.setColor(r,g,b,alpha)
	LG.rectangle("fill",border.x-border.w/2+1,border.y-border.h/2+1,border.w+1,border.h+1)--TODO floor these suckas

	LG.setColor(Game.palette[EC.black])
	LG.rectangle("fill",border.x-border.w/2,border.y-border.h/2,border.w,border.h)

	LG.setColor(Game.palette[border.c1])
	LG.rectangle("line",border.x-border.w/2,border.y-border.h/2,border.w,border.h)
end

return
{
	make = make,
	draw = draw,
}