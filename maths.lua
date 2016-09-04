--BRITISH STYLE motherfuckers

local function clamp(v,mi,ma,h)
	if h then
		if v<mi then v=mi
		elseif v>ma then v=ma
		end
	else
		if v<mi then v=ma
		elseif v>ma then v=mi
		end
	end
	return v
end

local function distance(x1,y1,x2,y2)
	--need to div by 10 bc numbers were getting way to big and overflowing, giving negatives output
	--local a=(x2-x1)/10  local b=(y2-y1)/10
	local a=(x2-x1)  local b=(y2-y1)
	return (a*a+b*b)
end

return
{
	clamp = clamp,
	distance = distance,
}