local ray={}

ray.cast = function(x,y,d,dist,step)
	local r={}
	r.d=d
	for j=step,dist,step do
		--local cellx=math.floor(x+math.cos(d)*j)
		--local celly=math.floor(y+math.sin(d)*j)
		local m=Game.level.map
		local cellx,celly=map.getcell(m,x+(math.cos(d)*j),y+(math.sin(d)*j))
		local cell=m[celly][cellx]
		if cell then
			--if cell==1 then
			if cell~=0 then
--[[
				local xlast=x+math.cos(d)*(j-step)
				local ylast=y+math.sin(d)*(j-step)
				local r2=ray.cast(xlast,ylast,d,step,step/10)
--]]
				--r.len=j+r2.len
				r.len=j
				return r
			end
		end
	end
	r.len=dist
	return r
end

return ray