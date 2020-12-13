local border={}

border.make = function(g,a,b,c1,c2)
	b.c1=c1
	b.c2=c2
end

border.draw = function(g,m,border)
	-- local alpha=230
	local alpha=0.9

	local r,gr,b=unpack(g.palette[border.c2])
	LG.setColor(r,gr,b,alpha)--TODO colour
	local x,y=math.floor(m.x-m.w/2),math.floor(m.y-m.h/2)
	LG.rectangle("fill",x+1,y+1,m.w+1,m.h+1)

	LG.setColor(g.palette["black"])
	LG.rectangle("fill",x,y,m.w,m.h)

	LG.setColor(g.palette[border.c1])--TODO colour
	LG.rectangle("line",x,y,m.w,m.h)
end

return border