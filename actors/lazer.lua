local function make(g,a)
	a.c=c or "blue"
	a.projvel=0
	a.rof=1
	a.num=1
	a.acc=0
	a.snd=25
	a.proj=EA.beam
end

local function draw(a)

end

local function shoot(g,a)
	local dist=300
	local lx,ly=a.x+a.vec[1]*dist,a.y+a.vec[2]*dist
	if lx<=0 then lx=1 end
	if lx>=g.width then lx=g.width-1 end
	if ly<=0 then ly=1 end
	if ly>=g.height then ly=g.height-1 end
	actor.make(g,a.proj,lx,ly,a.angle,0,"pure_white",a.x,a.y,a.angle)
end

return
{
	make = make,
	draw = draw,
	shoot = shoot,
}