local function make(g,a,c,size)
	a.cinit=c or EC.dark_purple
	a.c=a.cinit
	a.sizeinit=size or 20
	a.size=a.sizeinit
	a.anglespeed=0.01
	--a.flags=flags.switch(a.flags,EF.persistent)
end

local function control(g,a,gs)
	a.size=math.clamp(a.size+love.math.random(8)-4,1,20)

		--TODO make this a function. in pixelmaps?
		local tw,th=a.sizeinit*2,a.sizeinit*2
		local ix,iy=a.x-tw/2,a.y-th/2
		local ix2,iy2=ix+tw,iy+th
		if ix<0 then ix=0 end
		if iy<0 then iy=0 end
		if ix2>g.width then
			local diff=ix2-g.width
			tw=tw-diff
		end
		if iy2>g.height then
			local diff=iy2-g.height
			th=th-diff
		end

	local imgdata=g.canvas.background:newImageData(ix,iy,tw,th)

	imgdata:mapPixel(pixelmaps.sparkle)
	imgdata:mapPixel(pixelmaps.crush)

	a.image=LG.newImage(imgdata)

	local dist=vector.distance(a.x,a.y,g.player.x,g.player.y)
	if dist<20 then
		--TODO make level.change or something
		for i,v in pairs(g.actors) do
			if flags.get(v.flags,EF.enemy) and v.hp then
				actor.damage(v,v.hp)
			elseif not flags.get(v.flags,EF.persistent) then
				v.delete=true
			end
		end
		level.make(g,a.level,Enums.modes.topdown)
		g.ease=true--TODO make easing function for this. works on any number
		g.speed=0.01
		a.delete=true --TODO maybe give this a VERY low chance of not happening?
	end
end
--[[
local function draw(g,a)
	local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
	LG.setCanvas(g.canvas.background)
		LG.setColor(g.palette[EC.pure_white])
		LG.draw(a.image,a.x+xcamoff,a.y+ycamoff,0,1,1,a.sizeinit,a.sizeinit)
		LG.setColor(g.palette[a.c])
		local curve=love.math.newBezierCurve(
			a.x+xcamoff,
			a.y+ycamoff,
			a.x+xcamoff+math.cos(a.angle)*a.size/2,
			a.y+ycamoff+math.sin(a.angle)/2*a.size,
			a.x+xcamoff+math.cos(a.angle-1)*a.size,
			a.y+ycamoff+math.sin(a.angle-1)*a.size
		)
		local curve2=love.math.newBezierCurve(
			a.x+xcamoff,
			a.y+ycamoff,
			a.x+xcamoff-math.cos(a.angle)*a.size/2,
			a.y+ycamoff-math.sin(a.angle)/2*a.size,
			a.x+xcamoff-math.cos(a.angle-1)*a.size,
			a.y+ycamoff-math.sin(a.angle-1)*a.size)
		LG.line(curve:render(2))
		LG.line(curve2:render(2))
	LG.setCanvas(g.canvas.main)
end
--]]
local function draw(g,a)
	local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
	LG.setCanvas(g.canvas.background)
		LG.translate(xcamoff,ycamoff)
		LG.setColor(g.palette[EC.pure_white])
		LG.draw(a.image,a.x,a.y,0,1,1,a.sizeinit,a.sizeinit)
		LG.setColor(g.palette[a.c])
		local curve=love.math.newBezierCurve(
			a.x,
			a.y,
			a.x+math.cos(a.angle)*a.size/2,
			a.y+math.sin(a.angle)/2*a.size,
			a.x+math.cos(a.angle-1)*a.size,
			a.y+math.sin(a.angle-1)*a.size
		)
		local curve2=love.math.newBezierCurve(
			a.x,
			a.y,
			a.x-math.cos(a.angle)*a.size/2,
			a.y-math.sin(a.angle)/2*a.size,
			a.x-math.cos(a.angle-1)*a.size,
			a.y-math.sin(a.angle-1)*a.size)
		LG.line(curve:render(2))
		LG.line(curve2:render(2))
		LG.translate(-xcamoff,-ycamoff)
	LG.setCanvas(g.canvas.main)
end

return
{
	make = make,
	control = control,
	draw = draw,
}