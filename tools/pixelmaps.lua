local pixelmaps={}

pixelmaps.melt = function(x, y, r, g, b, a)
	if r~=0 or g~=0 or b~=0 then
		if love.math.random(2)==1 then
			-- r=math.max(r-4,0)
			-- g=math.max(g-1,0)
			-- b=math.max(b-4,0)
			r=math.max(r-0.02,0)
			g=math.max(g-0.01,0)
			b=math.max(b-0.02,0)
		end
	end
	return r,g,b,a
end

pixelmaps.sparkle = function(x, y, r, g, b, a)
	if r~=0 or g~=0 or b~=0 then
	-- if r>=0 or g>=0 or b>=0 then
		if love.math.random(2)==1 then
			-- r=r-10
			-- --g=g-10
			-- b=b-10
			r=r-0.04
			--g=g-10
			-- g=g-0.01
			b=b-0.04
		end
		r=math.clamp(r,0.04,1,true)
		-- g=math.snap(g,0.01,0)
		b=math.clamp(b,0.04,1,true)
--[[
		if love.math.random(100)==1 then
			r=0 g=0 b=0
		end
--]]
	end
	return r,g,b,a
end

pixelmaps.squish = function(x, y, r, g, b, a)
	if r~=0 or g~=0 or b~=0 then
	-- if r>=0 or g>=0 or b>=0 then
		if love.math.random(2)==1 then
			-- r=r-10
			-- --g=g-10
			-- b=b-10
			r=r-0.04
			--g=g-10
			g=g-0.04
			b=b-0.04
		end
		r=math.clamp(r,0.04,1,true)
		g=math.clamp(g,0.04,1,true)
		-- g=math.snap(g,0.01,0)
		b=math.clamp(b,0.04,1,true)
--[[
		if love.math.random(100)==1 then
			r=0 g=0 b=0
		end
--]]
	end
	return r,g,b,a
end

pixelmaps.crush = function(x, y, r, g, b, a)
	local xmid,ymid=20,20
	local dist=vector.distance(xmid,ymid,x,y)
	--if dist>=16 then
		local factor=dist/20
		local chance=math.floor(100/factor)
		if love.math.random(chance)==1 then
			r=0 g=0 b=0 a=0
		end
	--end
	return r,g,b,a
end

pixelmaps.wave = function(x, y, r, g, b, a)
	x=x+math.sin(g.timer*100)
	return r,g,b,a
end

return pixelmaps