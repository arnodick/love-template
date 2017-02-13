local function make(g)
	g.vel=0
	g.rof=1
	g.num=1
	g.acc=0
	g.snd=25
	g.proj=2
end

local function draw(g)

end

local function shoot(g)
	local dist=300
	local lx,ly=g.x+g.vec[1]*dist,g.y+g.vec[2]*dist
	if lx<=0 then lx=1 end
	if lx>=Game.width then lx=Game.width-1 end
	if ly<=0 then ly=1 end
	if ly>=Game.height then ly=Game.height-1 end
	actor.make(Enums.actors.projectile,g.proj,lx,ly,g.angle,0,Enums.colours.pure_white,g.x,g.y,g.angle)
end

return
{
	make = make,
	draw = draw,
	shoot = shoot,
}