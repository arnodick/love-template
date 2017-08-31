local function make(g,tw,th,gw,gh,sp)
	g.window={}
	g.window.width=640
	g.window.height=640
	local ww,wh=g.window.width,g.window.height
	g.bufferscale=(ww/tw)/ww
	g.canvas.window = LG.newCanvas(ww,wh)
	g.canvas.buffer = LG.newCanvas(ww*g.bufferscale,wh*g.bufferscale)

	g.chars={}
	table.insert(g.chars," ")
	table.insert(g.chars,"\\")
	table.insert(g.chars,"/")
	--table.insert(g.chars,",")
	--table.insert(g.chars,":")
	table.insert(g.chars,"-")
	table.insert(g.chars,"-")
	table.insert(g.chars,"-")
	--table.insert(g.chars,"=")
	--table.insert(g.chars,"+")
	--table.insert(g.chars,"*")
	table.insert(g.chars,"/")
	table.insert(g.chars,"|")
	table.insert(g.chars,"\\")
	--table.insert(g.chars,"#")
	--table.insert(g.chars,"@")
	table.insert(g.chars,"_")
	table.insert(g.chars,"~")

	game.state.make(g,Enums.games.states.intro)
end

return
{
	make = make,
}