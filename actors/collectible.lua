local function make(a,...)
	if _G[Enums.actors.collectibles[a.st]]["make"] then
		_G[Enums.actors.collectibles[a.st]]["make"](a,...)
	end
end

local function control(a,gs)
	local ea=Enums.actors
	if not flags.get(a.flags,Enums.flags.shopitem) then
		if actor.collision(a.x,a.y,Player) then	
			Player[ea.collectibles[a.st]] = Player[ea.collectibles[a.st]] + a.value
			if a.getsfx then
				sfx.play(a.getsfx)
			end
			actor.make(ea.effect,ea.effects.collectibleget,a.x,a.y,math.pi/2,1,Enums.colours.pure_white,1,a.sprinit)
			a.delete=true
		end
	else
		
	end
	if _G[ea.collectibles[a.st]]["control"] then
		_G[ea.collectibles[a.st]]["control"](a,gs)
	end
end

local function predraw(a)
	if a.menu then
		menu.draw(a.menu)
	end
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