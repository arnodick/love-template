local function make(a)
	a.hit=0
	a.hitsfx=3
	a.hittime=6
	a.hitcolour=7
	gun.make(a,1,9,-math.pi,0,Enums.colours.dark_purple)
	animation.make(a,10,2)
end

local function control(a)
	Game.speed=math.clamp(a.vel,0.1,1)
	if SFX.positonal then
		love.audio.setPosition(a.x,a.y,0)
	end
end


local function draw(a)

end

local function dead(a)
	scores.save()
end

return
{
	make = make,
	control = control,
	draw = draw,
	dead = dead,
}