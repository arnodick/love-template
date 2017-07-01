local function make(a,c,size,spr,hp)
	a.cinit=c or EC.red
	a.c=a.cinit
	a.size=size or 2
	a.spr=spr or 8
	a.hp=hp or 50

	a.value=1
	a.speed=1.5

	--module.make(a,EM.controller,EMC.move,EMI.ai,Player)
	module.make(a,EM.target,Player)
	--TODO make this stuff into some sort of function?
	local dir=vector.direction(vector.components(a.x,a.y,a.target.x,a.target.y))
	local dist=vector.distance(a.x,a.y,a.target.x,a.target.y)*1.5
	local x=math.clamp(a.x+math.cos(dir)*dist,0,Game.width)
	local y=math.clamp(a.y+math.sin(dir)*dist,0,Game.height)
	module.make(a,EM.controller,EMC.move,EMI.ai,x,y)
	module.make(a,EM.hit,3,6,EC.white)
	module.make(a,EM.animation,EM.animations.frames,6,2)
	module.make(a,EM.hitradius,8)
	a.flags=flags.set(a.flags,EF.character,EF.enemy,EF.damageable, EF.shootable, EF.explosive)
end

local function control(a)
	if actor.collision(a.x,a.y,a.target) then
		actor.damage(a.target,8)
		actor.damage(a,a.hp)
	end

	if a.controller.move then
		local t=a.controller.move.target
		local targetdistance=vector.distance(a.x,a.y,t.x,t.y)
		if targetdistance<=a.vel then
			a.controller.move=nil
		end
	else
		local dir=vector.direction(vector.components(a.x,a.y,a.target.x,a.target.y))
		local dist=vector.distance(a.x,a.y,a.target.x,a.target.y)*1.5
		local x=math.clamp(a.x+math.cos(dir)*dist,0,Game.width)
		local y=math.clamp(a.y+math.sin(dir)*dist,0,Game.height)
		module.make(a,EM.controller,EMC.move,EMI.ai,x,y)
		sfx.play(12)
	end

	if Player.hp<=0 then
		for i,v in ipairs(Game.actors) do
			if flags.get(v.flags,EF.enemy) then
				if v~=a then
					a.controller.move.target=v
				end
			end
		end
	end
end


local function draw(a)

end

local function dead(a)
	for i=1,3 do
		actor.make(EA[Enums.games[Game.t]].coin,a.x,a.y)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
	dead = dead,
}