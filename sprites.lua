local sprites={}

sprites.load = function(spr,i)
	local tw,th=8*2^(i-1),8*2^(i-1)--originally tw*2^(i-1),th*2^(i-1) where tw=8,th=8
	--takes in a spritesheet file(PNG) and some tile sizes
	--returns the spritesheet object and its QUADS
	local s={}
	s.spritesheet=LG.newImage(spr)
	s.quads={}
	local spritesheetW,spritesheetH=s.spritesheet:getWidth(),s.spritesheet:getHeight()
	local spritesheetTilesW,spritesheetTilesH=spritesheetW/tw,spritesheetH/th
	for y=0,spritesheetTilesH-1 do
		for x=0,spritesheetTilesW-1 do
			s.quads[x+y*spritesheetTilesW]=LG.newQuad(x*tw,y*th,tw,th,spritesheetW,spritesheetH)
		end
	end
	return s
end

--TODO this should maybe just go in actor? actor.draw with drawmode?
sprites.draw = function(a)
	local spr=a.spr
--[[
	if Game.actordata[EA[a.t] ] then
		spr=Game.actordata[EA[a.t] ].spr
	end
--]]
	if spr then
		--local size=a.size or Game.actordata[EA[a.t]].size
		local size=a.size or 1

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
		
		LG.draw(Sprites[size].spritesheet,Sprites[size].quads[spr+anim.frames],a.x,a.y,a.angle,scalex,scaley,(size*8)/2,(size*8)/2)
	end
end

sprites.blink = function(a,spd)
	if math.floor(Game.timer/spd)%2==0 then
		if a.spr then
			a.spr=nil
		end
	else
		a.spr=a.sprinit
	end
end

return sprites