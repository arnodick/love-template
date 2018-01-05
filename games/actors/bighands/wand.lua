local function make(g,a,c,user)
	a.spr=209
	a.size=1
	a.snd=2
	a.rof=4
	a.l=4
	a.tip={x=0,y=0}
	--a.angle=a.d
	--a.d=-a.d
	module.make(a,EM.item)
end

---[[
local function control(g,a)
	a.tip.x=a.x+(math.cos(a.angle)*a.l)
	a.tip.y=a.y+(math.sin(a.angle)*a.l)
end
--]]

local function shoot(a)
	actor.make(Game,EA[Game.name].bighands_bullet,a.tip.x,a.tip.y,a.angle,2)
	--actor.make(Game,EA[Game.name].bighands_beam,a.tip.x,a.tip.y,a.angle,0,EC.pure_white,a.tip.x,a.tip.y,a.angle)
end

return
{
	make = make,
	control = control,
	shoot = shoot,
}