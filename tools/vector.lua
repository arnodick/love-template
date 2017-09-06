local function components(x,y,x2,y2)
	return x2-x, y2-y
end

local function normalize(vx,vy)
	local l = vector.length(vx,vy)
	return vx/l, vy/l
end

local function length(x,y)
	return math.sqrt(x^2+y^2)
end

local function distance(x,y,x2,y2)
	local w,h = x2 - x, y2 - y
	return vector.length(w,h)
end

local function direction(vx,vy)
	return math.atan2(vy,vx)
end

local function mirror(vx,vy,hor)
	hor = hor or true
	if hor then
		vx = -vx
	else
		vy = -vy
	end
	return vx, vy
end

return
{
	components = components,
	normalize = normalize,
	length = length,
	distance = distance,
	direction = direction,
	mirror = mirror,
}