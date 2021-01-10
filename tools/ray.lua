local ray={}

--TODO consolidate this with raycaster game stuff?
ray.cast = function(g,x,y,d,dist,step)
	local r={}
	r.d=d
	for j=step,dist,step do
		local m=g.level.map
		local vx,vy=vector.vectors(d)
		local cellx,celly=map.getcellcoords(m,x+vx*j,y+vy*j)
		local cell=map.getcellraw(m,cellx,celly,true)
		if cell then
			if map.solid(cell) then
				local xlast=x+vx*(j-step)
				local ylast=y+vy*(j-step)
				local r2=ray.cast(g,xlast,ylast,d,step,step/10)
				r.len=j+r2.len
				return r
			end
		end
	end
	r.len=dist
	return r
end

return ray