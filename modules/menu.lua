local function make(a,m,t,x,y,w,h,text,c1,c2,align,...)
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
	if _G[EMM[m.t]]["make"] then
		_G[EMM[m.t]]["make"](m,...)
	end
end

local function control(m)
	if _G[EMM[m.t]]["control"] then
		_G[EMM[m.t]]["control"](m)
	end
end

local function keypressed(m,key)
	if _G[EMM[m.t]]["keypressed"] then
		_G[EMM[m.t]]["keypressed"](m,key)
	end
end

local function keyreleased(m,key)
	if _G[EMM[m.t]]["keyreleased"] then
		_G[EMM[m.t]]["keyreleased"](m,key)
	end
end

local function gamepadpressed(m,button)
	if _G[EMM[m.t]]["gamepadpressed"] then
		_G[EMM[m.t]]["gamepadpressed"](m,button)
	end
end

local function draw(m)
	local g=Game
	if m.border then
		border.draw(m,m.border)
	end
	LG.setFont(m.font)

	if _G[EMM[m.t]]["draw"] then
		_G[EMM[m.t]]["draw"](m)
	elseif type(m.text)=="table" then
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



--[[
	if Debugmode then
		LG.setColor(Game.palette[EC.red])
		LG.points(a.x,a.y)
	end
--]]
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	keyreleased = keyreleased,
	gamepadpressed = gamepadpressed,
	draw = draw,
}