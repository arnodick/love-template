local function load(spr,tw,th)
	--takes in a spritesheet file(PNG) and some tile sizes
	--returns the spritesheet object and its QUADS
	local ss = LG.newImage(spr)
	local quads={}
	local ssw,ssh=ss:getWidth(),ss:getHeight()
	print("ssw "..ssw)
	print("ssh "..ssh)
	local sswt,ssht=ssw/tw,ssh/th
	print("sswt "..sswt)
	print("ssht "..ssht)
	for y=0,ssht do
		for x=0,sswt do
			quads[x+y*sswt]=LG.newQuad(x*tw,y*th,tw,th,ssw,ssh)
		end
	end
	return spritesheet,quads
end

local function make(a)
--TODO this sprinit
end

local function draw(a)
	if a.spr then
		local anim={}
		anim.frames=0

		if a.animation then
			for k,v in pairs(a.animation) do
				anim[k]=animation.draw(k,v)
			end
		end

		local scalex,scaley=1,1
		if a.scalex then scalex=a.scalex end
		if a.scaley then scaley=a.scaley end
		
		LG.draw(Spritesheet[a.size],Quads[a.size][a.spr+anim.frames],a.x,a.y,a.angle,scalex,scaley,(a.size*Game.tile.width)/2,(a.size*Game.tile.height)/2)
	end
end

local function blink(a,spd)
	if math.floor(Game.timer/spd)%2==0 then
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