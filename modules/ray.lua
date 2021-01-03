local ray={}

--TODO consolidate this with raycaster game stuff?
ray.cast = function(g,x,y,d,dist,step)
	local r={}
	r.d=d
	for j=step,dist,step do
		local m=g.level.map
		local vx,vy=vector.vectors(d)
		local cell=map.getcellvalue(m,x+vx*j,y+vy*j)
		if cell then
			--if cell~=0 then
			if flags.get(cell,EF.solid,16) then
				r.len=j
				return r
			end
		end
	end
	r.len=dist
	return r
end

return ray