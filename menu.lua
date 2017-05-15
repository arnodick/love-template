local function make(t,x,y,w,h,text,c1,c2,align,...)
	local m={}
	m.t=t
	m.x=math.floor(x)
	m.y=math.floor(y)
	m.w=w
	m.h=h
	m.text=text--this can be a table or string
	m.c1=c1
	m.c2=c2
	m.align=align or "left"
	m.font=LG.newFont("fonts/Kongtext Regular.ttf",8)--TODO make fonts an array in game, then menu can select from them
	--table.insert(Game.menus,m)
	if _G[EM[m.t]]["make"] then
		_G[EM[m.t]]["make"](m,...)
	end
	return m
end

local function control(m)
	if _G[EM[m.t]]["control"] then
		_G[EM[m.t]]["control"](m)
	end
end

local function draw(m)
	if m.border then
		border.draw(m,m.border)
	end
	LG.setFont(m.font)
	if type(m.text)=="table" then
		for i=1,#m.text do
			local linealpha=255
			if m.text.index then
				if m.text.index~=i then
					linealpha=50
				end
			end
			LG.printformat(m.text[i],m.x-m.w/2,m.y-m.h/2+10*i,m.w,m.align,m.c1,m.c2,linealpha)
		end
	else
		LG.printformat(m.text,m.x-m.w/2,m.y-m.h/2,m.w,m.align,m.c1,m.c2)
	end
	LG.setFont(Game.font)

	if _G[EM[m.t]]["draw"] then
		_G[EM[m.t]]["draw"](m)
	end

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