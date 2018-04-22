local function make(g,a,c)
	a.c=c or EC.pure_white
	a.spr=210
	a.d=math.randomfraction(math.pi*2)
	a.vel=math.randomfraction(1)+1
	a.decel=0.01
	a.anglespeed=(a.vec[1]+math.choose(0,0,1,3))*(a.vel/60)
	a.flags=flags.set(a.flags,EF.bouncy,EF.persistent)
end

local function control(g,a)
	if a.vel<=0 then
		a.delete=true
	end
end

local function draw(g,a)
	local mw,mh=g.level.map.width,g.level.map.height
	if a.x>8 and a.x<mw-8 and a.y>8 and a.y<mh-8 then
		if a.vel<=0 then
			local m=g.level.map
			local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2

			local tw,th=g.level.map.tile.width,g.level.map.tile.height
			local ix,iy=a.x-tw/2-(xcamoff),a.y-th/2-(ycamoff)
			local ix2,iy2=ix+tw,iy+th

			local cw,ch=g.canvas.main:getWidth(),g.canvas.main:getHeight()
--[[
			if ix<1 then ix=1 end
			if iy<1 then iy=1 end
			if ix2>cw then
				local diff=ix2-cw
				tw=tw-diff
			end
			if iy2>ch then
				local diff=iy2-ch
				th=th-diff
			end
--]]
			if ix>8 and ix<cw-8 and iy>8 and iy<ch-8 then
				local imgdata=g.canvas.main:newImageData(ix,iy,tw,th)
				a.image=LG.newImage(imgdata)
				LG.drawtobackground(g.level.canvas.background,a.image,a.x,a.y,a.angle,1,1,(m.tile.width)/2,(m.tile.height)/2)
			end
		end
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
}