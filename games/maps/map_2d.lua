local function generate(m,w,h)
	for y=1,h do
		table.insert(m,{})
		for x=1,w do
			if x==1 or x==w or y==1 or y==h then
				local f=bit.lshift(1,(EF.solid-1))--converts an integer into its bit position
				f=bit.lshift(f,16)
				table.insert(m[y],f)
			else
				table.insert(m[y],0)
			end
		end
	end
end

local function draw(m)
	local tw,th=Game.tile.width,Game.tile.height
	if Game.levels then
		local c=Game.palette[Game.levels.current.c]
		local r=c[1]
		local g=c[2]
		local b=c[3]
		LG.setColor(r,g,b,120)
	else
		LG.setColor(Game.palette[EC.red])
	end

	for y=1,#m-1 do
		LG.line(0,y*th+1,Game.width,y*th+1)
	end
	for x=1,#m[1]-1 do
		LG.line(x*tw+1,0,x*tw+1,Game.height)
	end
end

return
{
	generate = generate,
	draw = draw,
}