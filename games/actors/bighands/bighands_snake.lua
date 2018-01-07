local function make(g,a,c,size,spr,hp)
	a.cinit=c or EC.dark_green
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 49
	a.hp=hp or 8

	--module.make(a,EM.controller,EMC.aim,EMCI.ai,g.player)
	--module.make(a,EM.controller,EMC.action,EMCI.ai,0.01,0)
	module.make(a,EM.sound,3,"damage")
	--module.make(a,EM.tail,a.cinit,9)
	--module.make(a,EM.inventory,1)
	--table.insert(a.inventory,actor.make(g,EA[g.name].machinegun,a.x,a.y,0,0,a.cinit,EC.green))
	module.make(a,EM.animation,EM.animations.frames,10,2)
	module.make(a,EM.hitradius,4)
	--module.make(a,EM.drop,"coin")
	a.flags=flags.set(a.flags,EF.bouncy,EF.enemy,EF.damageable,EF.shootable)

	a.d=math.choose(math.pi)
	a.vel=1
end

--[[
local function control(g,a)

end
--]]

--[[
local function draw(a)

end
--]]

return
{
	make = make,
	--control = control,
	--draw = draw,
}