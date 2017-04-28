local function dead(a)
	actor.corpse(a,Game.tile.width,Game.tile.height)
	Game.ease=true--TODO make easing function for this. works on any number
	local maxdist=vector.distance(0,0,Game.width,Game.height)
	Game.speed=0.05+vector.distance(Player.x,Player.y,a.x,a.y)/maxdist+math.choose(-0.02,0.03,0.05)
	local dropname=a.collectibledrop
	if dropname then
		local drop=actor.make(EA[dropname],math.floor(a.x),math.floor(a.y))
		if dropname=="portal" then --TODO clean this up
			drop.level=a.collectibledroplevel
		end
	end
end

return
{
	dead = dead,
}