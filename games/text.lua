local function make(g,tw,th,gw,gh,sp)
	g.window={}
	g.window.width=640
	g.window.height=640
	local ww,wh=g.window.width,g.window.height
	g.bufferscale=(ww/g.tile.width)/ww
	g.canvas.window = LG.newCanvas(ww,wh)
	g.canvas.buffer = LG.newCanvas(ww*g.bufferscale,wh*g.bufferscale)
	game.state.make(g,Enums.games.states.intro)
end

return
{
	make = make,
}