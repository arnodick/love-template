local function make(a,c,size)
	a.cinit=c or Enums.colours.dark_purple
	a.c=a.cinit
	a.sizeinit=size or 20
	a.size=a.sizeinit
	a.anglespeed=0.01
	--a.level=Levels.store
	a.level=Levels[Game.settings.level+1]
	a.flags=flags.set(a.flags,Enums.flags.persistent)
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

	a.image=love.graphics.newImage(imgdata)

	local dist=vector.distance(a.x,a.y,Player.x,Player.y)
	if dist<20 then
		for i,v in pairs(Actors) do
			if flags.get(v.flags,Enums.flags.enemy) then
				v.value=0
				actor.damage(v,v.hp)
			elseif not flags.get(v.flags,Enums.flags.persistent) then
				v.delete=true
			end
		end
		Game.settings.levelcurrent=level.make(a.level)
		a.delete=true --TODO maybe give this a VERY low chance of not happening?
	end
end

local function draw(a)
	love.graphics.setCanvas(Canvas.buffer)
		love.graphics.setColor(Palette[Enums.colours.pure_white])
		love.graphics.draw(a.image,a.x,a.y,0,1,1,a.sizeinit,a.sizeinit)
		love.graphics.setColor(Palette[a.c])
		local curve=love.math.newBezierCurve(a.x,a.y,a.x+math.cos(a.angle)*a.size/2,a.y+math.sin(a.angle)/2*a.size,a.x+math.cos(a.angle-1)*a.size,a.y+math.sin(a.angle-1)*a.size)
		local curve2=love.math.newBezierCurve(a.x,a.y,a.x-math.cos(a.angle)*a.size/2,a.y-math.sin(a.angle)/2*a.size,a.x-math.cos(a.angle-1)*a.size,a.y-math.sin(a.angle-1)*a.size)
		love.graphics.line(curve:render(2))
		love.graphics.line(curve2:render(2))
	love.graphics.setCanvas(Canvas.game)
end

return
{
	make = make,
	control = control,
	draw = draw,
}