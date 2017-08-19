local function dead(a)
	actor.corpse(a,Game.tile.width,Game.tile.height)
	--Game.ease=true--TODO make easing function for this. works on any number
	local maxdist=vector.distance(0,0,Game.width,Game.height)
	local initspeed=0.05+vector.distance(Game.player.x,Game.player.y,a.x,a.y)/maxdist+math.choose(-0.02,0.03,0.05)
	--Game.speed=0.05+vector.distance(Game.player.x,Game.player.y,a.x,a.y)/maxdist+math.choose(-0.02,0.03,0.05)
	module.make(Game,EM.transition,easing.outQuart,"speed",initspeed,1-initspeed,60)
	if a.drop then
		drop.spawn(a,a.x,a.y)
	end
end

return
{
	dead = dead,
}