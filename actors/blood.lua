local function make(g,a,c)
	a.c=c or EC.red
	a.d=math.randomfraction(math.pi*2)
	a.vel=math.randomfraction(2)+2
	a.decel=0.02
	a.alpha=200
	a.flags=flags.set(a.flags,EF.bouncy,EF.persistent)
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
	LG.points(a.x,a.y)
	if a.vel<=0 then
		LG.setCanvas(g.level.canvas.background)
			local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
			LG.points(a.x+xcamoff,a.y+ycamoff)
		LG.setCanvas(g.canvas.main)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
}