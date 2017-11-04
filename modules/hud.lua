local function make(s,h,t,...)
	if t then
		h.t=t
		run(EM.huds[t],"make",h,...)
	end
end

local function draw(g,h,...)
	if h.t then
		run(EM.huds[h.t],"draw",g,h,...)
	end

	if h.menu then
		menu.draw(h.menu)
	end
end

return
{
	make = make,
	draw = draw,
}