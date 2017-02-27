local function melt(x, y, r, g, b, a)
	if r~=0 or g~=0 or b~=0 then
		if love.math.random(2)==1 then
			r=math.max(r-4,0)
			g=math.max(g-1,0)
			b=math.max(b-4,0)
		end
	end
	return r,g,b,a
end

local function sparkle(x, y, r, g, b, a)
	if r~=0 or g~=0 or b~=0 then
		if love.math.random(2)==1 then
			r=r-10
			--g=g-10
			b=b-10
		end
		if love.math.random(100)==1 then
			r=0 g=0 b=0
		end
	end
	return r,g,b,a
end

return
{
	melt = melt,
	sparkle = sparkle,
}