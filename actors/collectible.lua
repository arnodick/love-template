local function make(a,...)
	if _G[EA.collectibles[a.st]]["make"] then
		_G[EA.collectibles[a.st]]["make"](a,...)
	end
end

local function control(a,gs)
	if not flags.get(a.flags,Enums.flags.shopitem) then
		if not a.spr then
			a.spr=a.sprinit
		end
		if actor.collision(a.x,a.y,Player) then
			if Player[EA.collectibles[a.st]] then
				Player[EA.collectibles[a.st]] = Player[EA.collectibles[a.st]] + a.value
			end
			for i,v in pairs(Actors) do
				if v.t==EA.collectible then
					if v.st==EA.collectibles.coin then
						v.scalex=4
						v.scaley=4
						v.deltimer=0
						v.delta=Timer
					end
				end
			end
			if a.getsfx then
				sfx.play(a.getsfx)
			end
			actor.make(EA.effect,EA.effects.collectibleget,a.x,a.y,math.pi/2,1,EC.pure_white,1,a.sprinit)
			if _G[EA.collectibles[a.st]]["get"] then
				_G[EA.collectibles[a.st]]["get"](a,gs)
			end
			a.delete=true
		end
	else

	end
	if _G[EA.collectibles[a.st]]["control"] then
		_G[EA.collectibles[a.st]]["control"](a,gs)
	end
end

local function predraw(a)

end

local function draw(a)
	if _G[EA.collectibles[a.st]]["draw"] then
		_G[EA.collectibles[a.st]]["draw"](a)
	end
end

return
{
	make = make,
	control = control,
	predraw = predraw,
	draw = draw,
}