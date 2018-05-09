local function make(g,a,c)
	a.c=c or EC.red
--	a.d=math.randomfraction(math.pi*2)
	a.spr=150+math.choose(0,1,2)
	a.angle=-a.d
	a.vel=math.randomfraction(2)+8
	a.scalex=4
	a.scaley=2
	--a.decel=0.02
	a.decel=0.16
	a.alpha=220+love.math.random(35)
	a.flags=flags.set(a.flags,EF.persistent)
end

local function control(g,a)
	if a.vel<=0 then
		a.delete=true
	end
end

local function draw(g,a)
--[[
	local mw,mh=g.level.map.width,g.level.map.height
	if a.x>8 and a.x<mw-8 and a.y>8 and a.y<mh-8 then
		LG.points(a.x,a.y)

		local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
		local ix,iy=a.x+xcamoff,a.y+ycamoff
		local cw,ch=g.canvas.main:getWidth(),g.canvas.main:getHeight()
		if ix>8 and ix<cw-8 and iy>8 and iy<ch-8 then
			if a.vel<=0 then
				LG.setCanvas(g.level.canvas.background)
					LG.points(ix,iy)
				LG.setCanvas(g.canvas.main)
			end
		end
	end
--]]
--[[
	LG.points(a.x,a.y)
	if a.vel<=0 then
		LG.setCanvas(g.level.canvas.background)
			local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
			LG.points(a.x+xcamoff,a.y+ycamoff)
			LG.points(a.x+xcamoff+a.vec[1],a.y+ycamoff+a.vec[2])
		LG.setCanvas(g.canvas.main)
	end
--]]
	local mw,mh=g.level.map.width,g.level.map.height
	local tw,th=g.level.map.tile.width*a.scalex,g.level.map.tile.height*a.scaley
--TODO put all this in drawtobackground
	if a.x>tw and a.x<mw-tw and a.y>th and a.y<mh-th then
		if a.vel<=0 then
			local m=g.level.map
			local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
			local ix,iy=a.x-tw/2-(xcamoff),a.y-th/2-(ycamoff)

			local cw,ch=g.canvas.main:getWidth(),g.canvas.main:getHeight()

			if ix>tw and ix<cw-tw and iy>th and iy<ch-th then
				local imgdata=g.canvas.main:newImageData(ix,iy,tw,th)
				a.image=LG.newImage(imgdata)
				--LG.drawtobackground(g.level.canvas.background,a.image,a.x,a.y,a.angle,a.scalex,a.scaley,(m.tile.width)/2,(m.tile.height)/2,230)
				LG.drawtobackground(g.level.canvas.background,a.image,a.x,a.y,0,1,1,(tw)/2,(th)/2,210)
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