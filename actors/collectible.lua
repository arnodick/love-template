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
			Player[ea.collectibles[a.st]] = Player[ea.collectibles[a.st]] + a.value
			if a.getsfx then
				sfx.play(a.getsfx)
			end
			actor.make(ea.effect,ea.effects.collectibleget,a.x,a.y,math.pi/2,1,Enums.colours.pure_white,1,a.sprinit)
			a.delete=true
		end
	else
		if vector.distance(a.x,a.y,Player.x,Player.y)<30 then
			sprites.blink(a,24)
			if Player.controller.powerup then
				if Player.coin>=a.cost then
					a.flags=flags.set(a.flags,Enums.flags.shopitem)
					actor.corpse(a.menu,a.menu.w+1,a.menu.h+1,true)
					actor.make(ea.effect,ea.effects.explosion,a.x,a.y,0,0,Enums.colours.white,40)
					a.menu=nil
					Player.coin=Player.coin-a.cost
				else
					sfx.play(11)
				end
			end
		else
			a.spr=a.sprinit
		end
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