local function make(a,t,c,len)
	t.c=c or EC.red
	t.leninit=len or 9
	t.len=t.leninit
	t.angle=0
	t.vec={0,0}

	t.sx=0
	t.sy=0
	t.x=0
	t.y=0
	t.mx=0
	t.my=0
end

local function control(t,gs,a,vx,vy)
	t.angle=vector.direction(vx,vy)
	t.vec[1]=math.cos(t.angle)
	t.vec[2]=math.sin(t.angle)

	if t.len<t.leninit then
		t.len = t.len + gs
	end
	local hack=0
	if t.angle < -1.4 then
		hack=1--NOTE: this is because the line wasn't drawing rom the proper origin because of... Math?
	end

	t.mx=a.x+8
	if math.abs(t.angle)<1 then
		t.my=a.y
	elseif t.angle<0 then
		t.my=a.y-6-math.floor((Game.timer/a.animation.frames.speed)%a.animation.frames.frames)*4
	else
		t.my=a.y+8+math.floor((Game.timer/a.animation.frames.speed)%a.animation.frames.frames)*4
	end
	t.x=a.x+t.vec[1]*t.len
	t.y=a.y+t.vec[2]*t.len
	t.sx=a.x+4
	t.sy=a.y
end

local function draw(t)
	LG.setColor(Game.palette[t.c])
	local curve=love.math.newBezierCurve(t.sx,t.sy,t.mx,t.my,t.x,t.y)
	LG.line(curve:render(2))
end

return
{
	make = make,
	control = control,
	draw = draw,
}