local function make(g,a,gx,gy,ga)
	a.gx=gx or 1
	a.gy=gy or 1
	a.ga=ga or 1
end

local function control(g,a,gs)
---[[
	local dam=0.1
	for i,enemy in ipairs(g.actors) do
		if flags.get(enemy.flags,EF.shootable) then
			if not enemy.delete then
				local ld=vector.direction(enemy.x,enemy.y,a.gx,a.gy)
				--TODO: fix this so that it doesnt jump from 0 to 1 when you try to check if ld is > gun angle
				if ld>a.ga-0.02*math.pi*2 and ld<a.ga+0.02*math.pi*2 then
					local dist=200
					actor.damage(g,enemy,dam)
				end
			end
		end
	end
--]]
	if g.timer-a.delta>=gs*4 then
		a.delete=true
	end
end

local function draw(g,a)
	local dist=vector.distance(a.gx,a.gy,a.x,a.y)
	--local dir=vector.direction(vector.components(a.x,a.y,a.gx,a.gy))
	local dir=a.ga
	--LG.points(a.gx,a.gy,a.x,a.y)
	
---[[
	for i=0,dist,2 do
		local x,y=a.gx+math.cos(dir)*i,a.gy+math.sin(dir)*i
		LG.circle("fill",x,y,3)
	end
--]]
end

return
{
	make = make,
	control = control,
	draw = draw,
}