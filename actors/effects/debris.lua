local function make(a,c)
	a.c=c or EC.orange
	a.d=math.randomfraction(math.pi*2)
	--a.vel=math.randomfraction(2)+2
	a.vel=math.randomfraction(4)+4
	a.decel=0.05
	a.anglespeed=(a.vec[1]+math.choose(0,0,3,8))*(a.vel/60)
	a.len=math.randomfraction(1)+1
	a.angleoff=math.randomfraction(math.pi)
	a.flags=flags.set(a.flags,EF.bouncy)
end

local function control(a)
	if a.vel<=0 then
		a.delete=true
	end
end

local function draw(a)
	if a.image then
		LG.draw(a.image,a.x,a.y,a.angle,1,1,(Game.tile.width)/2,(Game.tile.height)/2)
		if a.vel<=0 then
			LG.setCanvas(Canvas.buffer)
				LG.draw(a.image,a.x,a.y,a.angle,1,1,(Game.tile.width)/2,(Game.tile.height)/2)
			LG.setCanvas(Canvas.game)
		end
	else
		local xl,yl=math.cos(a.angle),math.sin(a.angle)
		local xl2,yl2=-math.cos(a.angle+a.angleoff),-math.sin(a.angle+a.angleoff)
		LG.line(a.x,a.y,a.x+xl*a.len,a.y+yl*a.len)
		--LG.line(a.x,a.y,a.x+xl*-a.len,a.y+yl*-a.len)
		LG.line(a.x,a.y,a.x+xl2*a.len,a.y+yl2*a.len)
		if a.vel<=0 then
			LG.setCanvas(Canvas.buffer)
				LG.line(a.x,a.y,a.x+xl*a.len,a.y+yl*a.len)
				--LG.line(a.x,a.y,a.x+xl*-a.len,a.y+yl*-a.len)
				LG.line(a.x,a.y,a.x+xl2*a.len,a.y+yl2*a.len)
			LG.setCanvas(Canvas.game)
		end
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
}