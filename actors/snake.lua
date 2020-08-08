local function make(g,a,c,size,spr,hp)
	a.cinit=c or "dark_green"
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 49
	a.hp=hp or 8

	a.value=1

	module.make(a,EM.controller,EMC.aim,EMCI.ai,g.player)
	module.make(a,EM.controller,EMC.action,EMCI.ai,0.01,0)
	module.make(a,EM.sound,3,"damage")
	module.make(a,EM.tail,a.cinit,9)
	module.make(a,EM.inventory,1)
	module.make(a,EM.animation,EM.animations.frames,10,2)
	module.make(a,EM.hitradius,4)
	module.make(a,EM.drop,"coin")
	a.flags=flags.set(a.flags,EF.character,EF.bouncy,EF.enemy,EF.damageable, EF.shootable, EF.explosive)

	a.d=math.choose(math.pi)
	a.vel=1
	a.rage=0

	local gun=actor.make(g,EA.machinegun,a.x,a.y,0,0,a.cinit,"green")
	item.pickup(g,gun,a)
end

local function control(g,a)
	a.rage=math.floor(g.score/5)

	if love.math.random( math.max(40-(a.rage*10),10) ) == 1 then
		a.controller.action.chance[1]=1
	else
		a.controller.action.chance[1]=0
	end

	if a.rage>0 then
		local acc=0.015*(a.rage+1)*2--TODO initacc for gun
		if a.inventory[1].acc~=acc then
			a.inventory[1].acc=acc
		end
		if math.floor(g.timer/(20-a.rage*5))%2==0 then
			if a.rage==1 then
				a.c="yellow"
			else
				a.c="red"
			end
		else
			a.c=a.cinit
		end
	end

	if g.player.hp<=0 then
		for i,v in ipairs(g.actors) do
			if flags.get(v.flags,EF.enemy) then
				if v~=a then
					a.controller.aim.target=v
				end
			end
		end
	end
end

--[[
local function draw(a)

end
--]]

return
{
	make = make,
	control = control,
	--draw = draw,
}