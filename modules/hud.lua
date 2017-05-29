local function make(s,h,t,...)
	h.t=t
	if _G[EM.huds[t]]["make"] then
		_G[EM.huds[t]]["make"](h,...)
	end
end

local function draw(g,h,...)
	if _G[EM.huds[h.t]]["draw"] then
		_G[EM.huds[h.t]]["draw"](g,h,...)
	end
end

return
{
	make = make,
	draw = draw,
}