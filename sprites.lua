local function load(spr, tw, th)
	--takes in a spritesheet file(PNG) and some tile sizes
	--returns the spritesheet object and its QUADS
	local spritesheet = LG.newImage(spr)
	local quads = {}
	local spritesheetW, spritesheetH = spritesheet:getWidth(), spritesheet:getHeight()
	local spritesheetTilesW,spritesheetTilesH = spritesheetW/tw, spritesheetH/th
	for b=0, spritesheetTilesH do
		for a=0, spritesheetTilesW do
			quads[a+b*spritesheetTilesW] = LG.newQuad(a*tw,b*th,tw,th,spritesheetW,spritesheetH)
		end
	end
	return spritesheet, quads
end

local function make(a)
--TODO this sprinit
end

local function draw(a)
	if a.spr then
		local anim=0
		if a.anim then
			anim=math.floor((Timer/a.anim.speed)%a.anim.frames)
		end
		local scalex,scaley=1,1
		if a.scalex then scalex=a.scalex end
		if a.scaley then scaley=a.scaley end
		
		LG.draw(Spritesheet[a.size],Quads[a.size][a.spr+anim],a.x,a.y,a.angle,scalex,scaley,(a.size*Game.tile.width)/2,(a.size*Game.tile.height)/2)
	end
end

local function blink(a,spd)
	if math.floor(Timer/spd)%2==0 then
		if a.spr then
			a.spr=nil
		end
	else
		a.spr=a.sprinit
	end
end

local function batchdraw(ss,qd,x,y,w,h)
	w=w or 1
	h=h or 1
	for b=0,h-1 do
		for a=0,w-1 do
			LG.draw(ss,Quads[1][qd+a+b*16],x+a*Game.tile.width,y+b*Game.tile.height)
		end
	end
end

return
{
	load = load,
	draw = draw,
	blink = blink,
	batchdraw = batchdraw,
}