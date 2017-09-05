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
			local value=m[y][x]
			--LG.draw(Spritesheet[3],Quads[3][value],isox,isoy,0,1,1,(y-1)*tw/2,(x-1)*-th/4)
			LG.print(value,(x-1)*tw,(y-1)*th)
		end
	end
--[[
	for y=1,#m-2 do
		LG.line(0,y*th+1,Game.width,y*th+1)
	end
	for x=1,#m[1]-2 do
		LG.line(x*tw+1,0,x*tw+1,Game.height)
	end
--]]
end

return
{
	generate = generate,
	draw = draw,
}