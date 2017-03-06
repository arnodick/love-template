local function make(a,...)
	if _G[Enums.actors.items[a.st]]["make"] then
		_G[Enums.actors.items[a.st]]["make"](a,...)
	end
end

local function control(a,gs)
	local ea=Enums.actors
	if actor.collision(a.x,a.y,Player) then	
		Player[ea.items[a.st]] = Player[ea.items[a.st]] + 1
		if a.getsfx then
			sfx.play(a.getsfx)
		end
		actor.make(ea.effect,ea.effects.itemget,a.x,a.y,math.pi/2,1,Enums.colours.pure_white,1,a.sprinit)
		a.delete=true
	end
	if _G[ea.items[a.st]]["control"] then
		_G[ea.items[a.st]]["control"](a,gs)
	end
end

local function draw(a)
	if _G[Enums.actors.items[a.st]]["draw"] then
		_G[Enums.actors.items[a.st]]["draw"](a)
	end
end

return
{
	make = make,
	control = control,
	use = use,
	draw = draw,
}