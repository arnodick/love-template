local function generate(m,w,h)
	for y=1,h do
		table.insert(m,{})
		for x=1,w do
			table.insert(m[y],x+(y-1)*w)
		end
	end
end

local function draw(m)
	if Debugger.debugging then
		local tw,th=Game.tile.width,Game.tile.height
		local t=Game.timer

		for y=1,#m do
			for x=1,#m[y] do
				local value=m[y][x]
				LG.print(value,(x-1)*tw*2,(y-1)*th*2)
			end
		end
	end
end

return
{
	generate = generate,
	draw = draw,
}