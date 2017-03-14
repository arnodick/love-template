local function make(a,...)
	if _G[Enums.actors.collectibles[a.st]]["make"] then
		_G[Enums.actors.collectibles[a.st]]["make"](a,...)
	end
end

local function control(a,gs)
	local ea=Enums.actors
	if not flags.get(a.flags,Enums.flags.shopitem) then
		if not a.spr then
			a.spr=a.sprinit
		end
		if actor.collision(a.x,a.y,Player) then
			if Player[ea.collectibles[a.st]] then
				Player[ea.collectibles[a.st]] = Player[ea.collectibles[a.st]] + a.value
			end
			for i,v in pairs(Actors) do
				if v.t==ea.collectible then
					v.scalex=4
					v.scaley=4
					v.deltimer=0
					v.delta=Timer
				end
			end
			if a.getsfx then
				sfx.play(a.getsfx)
			end
			actor.make(ea.effect,ea.effects.collectibleget,a.x,a.y,math.pi/2,1,Enums.colours.pure_white,1,a.sprinit)
			if _G[ea.collectibles[a.st]]["get"] then
				_G[ea.collectibles[a.st]]["get"](a,gs)
			end
			a.delete=true
		end
	else

	end
	if _G[ea.collectibles[a.st]]["control"] then
		_G[ea.collectibles[a.st]]["control"](a,gs)
	end
end

local function predraw(a)

end

local function draw(a)
	--local lg=love.graphics
	--if flags.get(a.flags,Enums.flags.shopitem) then
	--	lg.setColor(Palette[Enums.colours.white])
	--	lg.printf("$1",a.x-10,a.y-16,20,"center")
	--end
	if _G[Enums.actors.collectibles[a.st]]["draw"] then
		_G[Enums.actors.collectibles[a.st]]["draw"](a)
	end
end

return
{
	make = make,
	control = control,
	predraw = predraw,
	draw = draw,
}