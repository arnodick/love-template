local function make(a,...)
	a.flags = flags.set(a.flags, EF.damageable, EF.shootable, EF.explosive)
	hitradius.make(a,4)
	--if Game.level==Game.levels.current then
	if Game.levels.current then
		local spawnnum=(Game.score-1)%(#Game.levels.current.enemies)+1
		if Game.levels.current.collectibledrops[spawnnum] then
			a.collectibledrop=Game.levels.current.collectibledrops[spawnnum]
		end
	end
	if _G[EA.characters[a.st]]["make"] then
		_G[EA.characters[a.st]]["make"](a,...)
	end
end

local function control(a,gs)
	if _G[EA.characters[a.st]]["control"] then
		_G[EA.characters[a.st]]["control"](a)
	end
end

local function draw(a)
	if _G[EA.characters[a.st]]["draw"] then
		_G[EA.characters[a.st]]["draw"](a)
	end
end

local function collision(a)
	if _G[EA.characters[a.st]]["collision"] then
		_G[EA.characters[a.st]]["collision"](a)
	end
end

local function damage(a)
	if _G[EA.characters[a.st]]["damage"] then
		_G[EA.characters[a.st]]["damage"](a)
	end
end

local function dead(a)
	actor.corpse(a,Game.tile.width,Game.tile.height)
	Game.ease=true--TODO make easing function for this. works on any number
	local maxdist=vector.distance(0,0,Game.width,Game.height)
	Game.speed=0.05+vector.distance(Player.x,Player.y,a.x,a.y)/maxdist+math.choose(-0.02,0.03,0.05)
	if a.collectibledrop then
		local dropname=a.collectibledrop
		--local port=actor.make(EA.effect,EA.effects.portal,math.floor(a.x),math.floor(a.y))
		local drop=actor.make(EA.collectible,EA.collectibles[dropname],math.floor(a.x),math.floor(a.y))
		if dropname=="portal" then --TODO clean this up
			drop.level=Game.levels.store
		end
	end

	if _G[EA.characters[a.st]]["dead"] then
		_G[EA.characters[a.st]]["dead"](a)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
	collision = collision,
	damage = damage,
	dead = dead,
}