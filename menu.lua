local function make(t,x,y,w,h,text,c1,c2,...)
	local m={}
	m.t=t
	m.x=math.floor(x)
	m.y=math.floor(y)
	m.w=w
	m.h=h
	m.text=text--this cab a table or string
	m.c1=c1
	m.c2=c2
	--m.font=LG.newFont("fonts/pico8.ttf",8)--TODO make fonts an array in game, then menu can select from them
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
		border.draw(m.border)
	end
--[[
	local alpha=230

	local r,g,b=unpack(Game.palette[m.bc2])
	LG.setColor(r,g,b,alpha)
	LG.rectangle("fill",m.x-m.w/2+1,m.y-m.h/2+1,m.w+1,m.h+1)--TODO floor these suckas

	LG.setColor(Game.palette[EC.black])
	LG.rectangle("fill",m.x-m.w/2,m.y-m.h/2,m.w,m.h)

	LG.setColor(Game.palette[m.bc1])
	LG.rectangle("line",m.x-m.w/2,m.y-m.h/2,m.w,m.h)
--]]

	LG.setFont(m.font)
	if type(m.text)=="table" then
		for i=1,#m.text do
			local linealpha=255
			if m.text.index then
				if m.text.index~=i then
					linealpha=50
				end
			end
			LG.printshadow(m.text[i],m.x-m.w/2,m.y-m.h/2+10*i,m.w,"left",m.c1,m.c2,linealpha)
		end
	else
		LG.printshadow(m.text,m.x-m.w/2,m.y-m.h/2,m.w,"left",m.c1,m.c2)
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