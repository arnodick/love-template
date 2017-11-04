local function make(g,t,...)
	g.hud={}
	if t then
		g.hud.t=t
		run(EM.huds[t],"make",g.hud,...)
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