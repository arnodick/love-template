local function make(a,c,size)
	a.cinit=c or EC.dark_purple
	a.c=a.cinit
	a.sizeinit=size or 20
	a.size=a.sizeinit
	a.anglespeed=0.01
	a.level=Game.levels[Game.level+1]
	a.flags=flags.set(a.flags,EF.persistent)
end

local function control(a,gs)
	a.size=math.clamp(a.size+love.math.random(8)-4,1,20)

		--TODO make this a function. in pixelmaps?
		local tw,th=a.sizeinit*2,a.sizeinit*2
		local ix,iy=a.x-tw/2,a.y-th/2
		local ix2,iy2=ix+tw,iy+th
		if ix<0 then ix=0 end
		if iy<0 then iy=0 end
		if ix2>Game.width then
			local diff=ix2-Game.width
			tw=tw-diff
		end
		if iy2>Game.height then
			local diff=iy2-Game.height
			th=th-diff
		end

	local imgdata=Canvas.buffer:newImageData(ix,iy,tw,th)

	imgdata:mapPixel(pixelmaps.sparkle)
	imgdata:mapPixel(pixelmaps.crush)

	a.image=LG.newImage(imgdata)

	local dist=vector.distance(a.x,a.y,Player.x,Player.y)
	if dist<20 then
		for i,v in pairs(Game.actors) do
			if flags.get(v.flags,EF.enemy) then
				v.value=0
				actor.damage(v,v.hp)
			--elseif v.t==EA.collectible then
			--	v.x=Player.x
			--	v.y=Player.y
			elseif not flags.get(v.flags,EF.persistent) then
				v.delete=true
			end
		end
		Game.levels.current=level.make(a.level)--TODO make level.change function
		Game.ease=true--TODO make easing function for this. works on any number
		local maxdist=vector.distance(0,0,Game.width,Game.height)
		Game.speed=0.01

		a.delete=true --TODO maybe give this a VERY low chance of not happening?
	end
end

local function draw(a)
	LG.setCanvas(Canvas.buffer)
		LG.setColor(Palette[EC.pure_white])
		LG.draw(a.image,a.x,a.y,0,1,1,a.sizeinit,a.sizeinit)
		LG.setColor(Palette[a.c])
		local curve=love.math.newBezierCurve(a.x,a.y,a.x+math.cos(a.angle)*a.size/2,a.y+math.sin(a.angle)/2*a.size,a.x+math.cos(a.angle-1)*a.size,a.y+math.sin(a.angle-1)*a.size)
		local curve2=love.math.newBezierCurve(a.x,a.y,a.x-math.cos(a.angle)*a.size/2,a.y-math.sin(a.angle)/2*a.size,a.x-math.cos(a.angle-1)*a.size,a.y-math.sin(a.angle-1)*a.size)
		LG.line(curve:render(2))
		LG.line(curve2:render(2))
	LG.setCanvas(Canvas.game)
end

return
{
	make = make,
	control = control,
	draw = draw,
}