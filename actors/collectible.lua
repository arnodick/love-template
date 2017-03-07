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

local function draw(a)
	if flags.get(a.flags,Enums.flags.shopitem) then
		love.graphics.print("$ 1",a.x,a.y-10)
	end
	if _G[Enums.actors.collectibles[a.st]]["draw"] then
		_G[Enums.actors.collectibles[a.st]]["draw"](a)
	end
end

return
{
	make = make,
	control = control,
	use = use,
	draw = draw,
}