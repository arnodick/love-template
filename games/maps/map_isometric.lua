local function generate(m,w,h)
	local pool={1,1,1,1,2,3,4}
	for y=1,h do
		table.insert(m,{})
		for x=1,w do
			table.insert(m[y],pool[love.math.random(#pool)])
		end
	end
end

local function draw(m)
	local tw,th=Game.tile.width,Game.tile.height
	local t=Game.timer

	for y=1,#m do
		for x=1,#m[y] do
			--if (y-1)*#m[y]+x<=t then
				local isox=(x-1)*tw/2
				local isoy=(y-1)*th/4
				local value=m[y][x]
				--LG.draw(Spritesheet[3],Quads[3][value],isox+230,isoy+50,0,1,1,(y-1)*tw/2,(x-1)*-th/4)
				LG.draw(Spritesheet[3],Quads[3][value],isox,isoy,0,1,1,(y-1)*tw/2,(x-1)*-th/4)
				if Debugger.debugging then
					LG.points(isox,isoy)
				end
				
			--end
		end
	end
end

return
{
	generate = generate,
	draw = draw,
}