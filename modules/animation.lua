local function make(m,t,...)
	m[EM.animations[t]]={}
	if _G[EM.animations[t]]["make"] then
		_G[EM.animations[t]]["make"](m[EM.animations[t]],...)
	end
end

local function draw(animname,anim)
	if _G[animname]["draw"] then
		return _G[animname]["draw"](anim)
	end
end

return
{
	make = make,
	draw = draw,
}