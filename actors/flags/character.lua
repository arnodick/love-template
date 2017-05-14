local function dead(a)
	actor.corpse(a,Game.tile.width,Game.tile.height)
	Game.ease=true--TODO make easing function for this. works on any number
	local maxdist=vector.distance(0,0,Game.width,Game.height)
	Game.speed=0.05+vector.distance(Player.x,Player.y,a.x,a.y)/maxdist+math.choose(-0.02,0.03,0.05)
	if a.drop then
		drop.spawn(a,a.x,a.y)
	end
end

return
{
	dead = dead,
}