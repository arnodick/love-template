local function make(a,c,size,spr,hp,ct)
	local e=Enums
	local playercontroller=e.controllers.keyboard
	if #Joysticks>0 then
		playercontroller=e.controllers.gamepad
	end
	a.cinit=c or e.colours.dark_blue
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 81
	a.hp=hp or 8
	controller.make(a,playercontroller)
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