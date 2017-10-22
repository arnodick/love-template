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
	draw = draw,
}