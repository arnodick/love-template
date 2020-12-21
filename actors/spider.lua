local function make(g,a,c,size,spr,hp)
	a.cinit=c or "red"
	a.c=a.cinit
	a.size=size or 2
	a.spr=spr or 8
	a.hp=hp or 50

	a.value=1
	a.speed=1.5

	module.make(g,a,EM.target,g.player)
	
	--TODO make this stuff into some sort of function?
	local dir=vector.direction(a.x,a.y,a.target.x,a.target.y)
	local dist=vector.distance(a.x,a.y,a.target.x,a.target.y)*1.5
	local x=math.clamp(a.x+math.cos(dir)*dist,0,g.width)
	local y=math.clamp(a.y+math.sin(dir)*dist,0,g.height)
	module.make(g,a,EM.controller,EMC.move,EMCI.ai,x,y)

	module.make(g,a,EM.sound,3,"damage")
	module.make(g,a,EM.animation,EM.animations.frames,6,2)
	module.make(g,a,EM.hitradius,8)
	a.flags=flags.set(a.flags,EF.character,EF.enemy,EF.damageable, EF.shootable, EF.explosive)

	sfx.play(g,12)
end

local function control(g,a)
	if actor.collision(a.x,a.y,a.target) then
		actor.damage(g,a.target,8)
		actor.damage(g,a,a.hp)
	end

	if a.controller.move.target then
		local t=a.controller.move.target
		local targetdistance=vector.distance(a.x,a.y,t.x,t.y)
		if targetdistance<=a.vel then
			a.controller.move.target=nil
		end
	end
	if not a.controller.move.target then
		local dir=vector.direction(a.x,a.y,a.target.x,a.target.y)
		local dist=vector.distance(a.x,a.y,a.target.x,a.target.y)*1.5
		local x=math.clamp(a.x+math.cos(dir)*dist,0,g.width)
		local y=math.clamp(a.y+math.sin(dir)*dist,0,g.height)
		module.make(g,a,EM.controller,EMC.move,EMCI.ai,x,y)
		sfx.play(g,12)
	end

	if g.player.hp<=0 then
		for i,v in ipairs(g.actors) do
			if flags.get(v.flags,EF.enemy) then
				if v~=a then
					a.controller.move.target=v
				end
			end
		end
	end
end

--[[
local function draw(a)

end
--]]

local function dead(g,a)
	for i=1,3 do
		actor.make(g,EA.coin,a.x,a.y)
	end
end

return
{
	make = make,
	control = control,
	--draw = draw,
	dead = dead,
}