--TODO maybe put this in math?
local vector={}

--TODO vector.vectors? return math.cos, math.sin of x and y vecs, normalize to 0 - 1 range

vector.components = function(x,y,x2,y2)
	return x2-x,y2-y
end

vector.normalize = function(vx,vy)
	local l=vector.length(vx,vy)
	return vx/l, vy/l
end

vector.length = function(x,y)
	return math.sqrt(x^2+y^2)
end

vector.distance = function(x,y,x2,y2)
	local w,h=x2-x,y2-y
	return vector.length(w,h)
end

vector.direction = function(vx,vy,tx,ty)
--TODO just do components in here?
--TODO normalize to 0 - 1 range
--TODO use modulo trick? https://stackoverflow.com/questions/1311049/how-to-map-atan2-to-degrees-0-360
	if tx and ty then
		-- vx,vy=vector.components(tx,ty,vx,vy)
		vx,vy=vector.components(vx,vy,tx,ty)
	-- 	print("VECTOR COMP x: "..vx.." y: "..vy)
	-- else
	-- 	print("VECTOR x: "..vx.." y: "..vy)
	end

	local dir=math.atan2(vy,vx)
	if dir<0 then
		-- print("DIR IS: "..dir)
		dir=math.abs(dir+math.pi*2)
		-- print("NEW DIR IS: "..dir)
	end
	return dir
end

vector.mirror = function(vx,vy,hor)
	hor=hor or true
	if hor then
		vx=-vx
	else
		vy=-vy
	end
	return vx,vy
end

return vector