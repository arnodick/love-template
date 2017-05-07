local function make(a,c,size,spr,hp,ct)
	a.cinit=c or EC.yellow
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 97
	a.hp=hp or 16
	controller.make(a,ECT.move,ECT.moves.ai_target_avoid,Player)
	a.hit=0
	a.hitsfx=3
	a.hittime=6
	a.hitcolour=7
	a.value=1
	a.speed=2

	animation.make(a,10,2)
	hitradius.make(a,4)
	a.flags=flags.set(a.flags,EA.flags.character,EF.enemy,EF.damageable, EF.shootable, EF.explosive)

	Game.levels.current.enemies.max=math.clamp(Game.levels.current.enemies.max+1,1,Game.levels.current.enemies.maxlimit)
end

local function control(a)
	if love.math.random(10000)==1 then
		local smolhp=actor.make(EA.hp,a.x,a.y,0,0,EC.red,1,129)
		smolhp.value=1
		smolhp.scalex=0.5
		smolhp.scaley=0.5
	end

--[[
	local maxdist=100
	local dir=vector.direction(vector.components(a.x,a.y,a.target.move.x,a.target.move.y))
	local dist=vector.distance(a.x,a.y,a.target.move.x,a.target.move.y)

	if not a.destination then
		--avoid
		if dist<maxdist then
			if a.x>Game.width-32 or a.x<32 or a.y>Game.height-32 or a.y<32 then
				a.destination={}
				a.destination.x,a.destination.y=love.math.random(Game.width),love.math.random(Game.height)
				local movedist=vector.distance(a.destination.x,a.destination.y,a.target.move.x,a.target.move.y)
				while movedist<maxdist do
					a.destination.x,a.destination.y=love.math.random(Game.width),love.math.random(Game.height)
					movedist=vector.distance(a.destination.x,a.destination.y,a.target.move.x,a.target.move.y)
				end
				dir=vector.direction(vector.components(a.x,a.y,a.destination.x,a.destination.y))
				c.movehorizontal=math.cos(dir)
				c.movevertical=math.sin(dir)
			else
				a.destination=nil
				c.movehorizontal=-math.cos(dir)
				c.movevertical=-math.sin(dir)
			end
		--random jitter
		else
			a.destination=nil
			local x,y=love.math.random(Game.width),love.math.random(Game.height)
			local movedist=vector.distance(x,y,a.target.move.x,a.target.move.y)
			while movedist<maxdist do
				x,y=love.math.random(Game.width),love.math.random(Game.height)
				movedist=vector.distance(x,y,a.target.move.x,a.target.move.y)
			end
			local movedir=vector.direction(vector.components(a.x,a.y,x,y))
			c.movehorizontal=math.cos(movedir)
			c.movevertical=math.sin(movedir)
		end
	end

	a.d=vector.direction(c.movehorizontal,-c.movevertical)
	a.vel=vector.length(c.movehorizontal,c.movevertical)*a.speed
--]]
end

local function dead(a)

end

return
{
	make = make,
	control = control,
	dead = dead,
}