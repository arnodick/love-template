local function make(x,y,w,h,text,c1,c2,bc1,bc2)
--TODO make menu types
	local m={}
	m.x=math.floor(x)
	m.y=math.floor(y)
	m.w=w
	m.h=h
	m.text=text--this is table
	m.c1=c1
	m.c2=c2
	m.bc1=bc1
	m.bc2=bc2
	--table.insert(Menus,m)
	return m
end

local function control(m)

end

local function draw(m)
	local c=Enums.colours
	local g=love.graphics

	g.setColor(Palette[m.bc2])
	g.rectangle("fill",m.x-m.w/2+1,m.y-m.h/2+1,m.w+1,m.h+1)--TODO floor these suckas

	g.setColor(Palette[c.black])
	g.rectangle("fill",m.x-m.w/2,m.y-m.h/2,m.w,m.h)

	g.setColor(Palette[m.bc1])
	g.rectangle("line",m.x-m.w/2,m.y-m.h/2,m.w,m.h)

	--g.print("u will buy",a.x+xoff/2,a.y+yoff/2)
	for i=1,#m.text do
		g.printborder(m.text[i],m.x-m.w/2,m.y-m.h/2+10*i,m.c1,m.c2,m.w)
	end

	if Debugmode then
		g.setColor(Palette[c.red])
		g.points(a.x,a.y)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
}