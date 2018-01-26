local function make(g,t,...)
	g.hud={}
	if t then
		g.hud.t=t
		game.state.run(g.name,"hud","make",g.hud,...)
	end
end

local function draw(g,h,...)
	if h.t then
		game.state.run(g.name,"hud","draw",g,h,...)
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