local function make(a,c,size,spr,hp,ct)
	a.cinit=c or EC.dark_green
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 49
	a.hp=hp or 8
	controller.make(a,ECT.aim,ECT.aims.ai_shoot_accurate,Player)
	a.hit=0
	a.hitsfx=3
	a.hittime=6
	a.hitcolour=7
	a.value=1
	tail.make(a,a.cinit,9)
	a.inv={}
	table.insert(a.inv,actor.make(EA.machinegun,a.x,a.y,0,0,a.cinit,EC.green))
	animation.make(a,10,2)
	hitradius.make(a,4)
	drop.generate(a,"coin")
	a.flags=flags.set(a.flags,EA.flags.character,EF.bouncy,EF.enemy,EF.damageable, EF.shootable, EF.explosive)
	a.d=math.choose(math.pi)
	a.vel=1
	a.rage=0
end

local function control(a)
	a.rage=math.floor(Game.score/5)
	a.c=a.cinit+a.rage
	if Player.hp<=0 then
		for i,v in ipairs(Game.actors) do
			if flags.get(v.flags,EF.enemy) then
				if v~=a then
					a.target.aim=v
				end
			end
		end
	end
end

local function draw(a)

end

--[[
local function dead(a)
	actor.make(EA.coin,a.x,a.y)
end
-]]

return
{
	make = make,
	control = control,
	draw = draw,
	--dead = dead,
}