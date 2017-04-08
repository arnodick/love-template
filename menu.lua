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
	--m.font=LG.newFont("fonts/pico8.ttf",8)--TODO make fonts an array in game, then menu can select from them
	m.font=LG.newFont("fonts/Kongtext Regular.ttf",8)--TODO make fonts an array in game, then menu can select from them
	--table.insert(Game.menus,m)
	return m
end

local function control(m)

end

local function draw(m)
	LG.setFont(m.font)
	local alpha=230
	local r,g,b=unpack(Game.palette[m.bc2])

	LG.setColor(r,g,b,alpha)
	LG.rectangle("fill",m.x-m.w/2+1,m.y-m.h/2+1,m.w+1,m.h+1)--TODO floor these suckas

	LG.setColor(Game.palette[EC.black])
	LG.rectangle("fill",m.x-m.w/2,m.y-m.h/2,m.w,m.h)

	LG.setColor(Game.palette[m.bc1])
	LG.rectangle("line",m.x-m.w/2,m.y-m.h/2,m.w,m.h)

	if type(text)=="table" then
		for i=1,#m.text do
			LG.printborder(m.text[i],m.x-m.w/2,m.y-m.h/2+10*i,m.c1,m.c2,m.w)
		end
	else
		LG.printborder(m.text,m.x-m.w/2,m.y-m.h/2,m.c1,m.c2,m.w)
	end
	LG.setFont(Game.font)

	if Debugmode then
		LG.setColor(Game.palette[EC.red])
		LG.points(a.x,a.y)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
}