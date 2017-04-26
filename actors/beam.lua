local function make(a,gx,gy,ga)
	a.gx=gx
	a.gy=gy
	a.ga=ga
end

local function control(a,gs)
	local dam=0
	for i,enemy in ipairs(Game.actors) do
		if flags.get(enemy.flags,EF.shootable) then
			if not enemy.delete then
				local ld=vector.direction(enemy.x-a.gx,enemy.y-a.gy)
				--TODO: fix this so that it doesnt jump from 0 to 1 when you try to check if ld is > gun angle
				if ld>a.ga-0.02*math.pi*2 and ld<a.ga+0.02*math.pi*2 then
					local dist=200
					actor.damage(enemy,0)
				end
			end
		end
	end
	if Game.timer-a.delta>=gs*3 then
		a.delete=true
	end
end

local function draw(a)
	local dist=vector.distance(a.gx,a.gy,a.x,a.y)
	local dir=vector.direction(vector.components(a.gx,a.gy,a.x,a.y))
	for i=10,dist,5 do
		local x,y=a.gx+math.cos(dir)*i,a.gy+math.sin(dir)*i
		LG.circle("fill",x,y,6)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
}