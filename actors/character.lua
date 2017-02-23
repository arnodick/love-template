local function make(a,...)
	a.flags = flags.set(a.flags, Enums.flags.damageable, Enums.flags.shootable, Enums.flags.explosive)
	hitbox.make(a,-4,-4,8,8)
	if _G[Enums.actors.characters[a.st]]["make"] then
		_G[Enums.actors.characters[a.st]]["make"](a,...)
	end
end

local function control(a)
	if _G[Enums.actors.characters[a.st]]["control"] then
		_G[Enums.actors.characters[a.st]]["control"](a)
	end
end

local function draw(a)
	if _G[Enums.actors.characters[a.st]]["draw"] then
		_G[Enums.actors.characters[a.st]]["draw"](a)
	end
end

local function collision(a)
	if _G[Enums.actors.characters[a.st]]["collision"] then
		_G[Enums.actors.characters[a.st]]["collision"](a)
	end
end

local function damage(a)
	if _G[Enums.actors.characters[a.st]]["damage"] then
		_G[Enums.actors.characters[a.st]]["damage"](a)
	end
end

local function dead(a)
	--for i=1,20 do
		local e=Enums
		local body=actor.make(e.actors.effect,e.actors.effects.spark,a.x,a.y)
		body.decel=0.1
		local dir=math.randomfraction(math.pi*2)
		--local body=Actors[#Actors]
		local tw,th=Game.tile.width,Game.tile.height
		local ix,iy=a.x-tw/2,a.y-th/2
		local ix2,iy2=ix+tw,iy+th
		if ix<0 then ix=0 end
		if iy<0 then iy=0 end
		if ix2>Game.width then
			local diff=ix2-Game.width
			tw=tw-diff
		end
		if iy2>Game.height then
			local diff=iy2-Game.height
			th=th-diff
		end
		
		local choice=math.choose(1,2)
		if choice==1 then
			local imgdata=Canvas.game:newImageData(ix,iy,tw,th)--TODO this crashes if it goes off canvas. clamp it
			body.image=love.graphics.newImage(imgdata)
		else
			local imgdata=Canvas.game:newImageData(ix,iy,tw/2,th)--TODO this crashes if it goes off canvas. clamp it
			body.image=love.graphics.newImage(imgdata)
			body.d=dir

			local body2=actor.make(e.actors.effect,e.actors.effects.spark,a.x,a.y)
			body2.decel=0.1
			local imgdata2=Canvas.game:newImageData(ix+tw/2,iy,tw/2,th)--TODO this crashes if it goes off canvas. clamp it
			body2.image=love.graphics.newImage(imgdata2)
			body2.d=dir+math.randomfraction(0.5)-0.25
		end
	--end
	if _G[Enums.actors.characters[a.st]]["dead"] then
		_G[Enums.actors.characters[a.st]]["dead"](a)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
	collision = collision,
	damage = damage,
	dead = dead,
}