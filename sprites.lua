local function load(spr, tw, th)
	--takes in a spritesheet file(PNG) and some tile sizes
	--returns the spritesheet object and its QUADS
	local spritesheet = love.graphics.newImage(spr)
	local quads = {}
	local spritesheetW, spritesheetH = spritesheet:getWidth(), spritesheet:getHeight()
	local spritesheetTilesW,spritesheetTilesH = spritesheetW/tw, spritesheetH/th
	for b=0, spritesheetTilesH do
		for a=0, spritesheetTilesW do
			quads[a+b*spritesheetTilesW] = love.graphics.newQuad(a*tw,b*th,tw,th,spritesheetW,spritesheetH)
		end
	end
	return spritesheet, quads
end

local function draw(ss,qd,x,y,w,h)
	w=w or 1
	h=h or 1
	for b=0,h-1 do
		for a=0,w-1 do
			love.graphics.draw(ss,Quads[1][qd+a+b*16],x+a*Game.tile.width,y+b*Game.tile.height)
		end
	end
end

return
{
	load = load,
	draw = draw,
}