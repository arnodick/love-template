local function make(a,c,size,spr,hp,ct)
	local e=Enums
	local ea=e.actors

	if #Joysticks>0 then
		controller.make(a,e.controllers.gamepad)
	else
		a.cursor=cursor.make(0,0)
		controller.make(a,e.controllers.keyboard,e.controllers.mouse)
	end

	a.cinit=c or e.colours.dark_blue
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 81
	a.hp=hp or 8
	a.hit=0
	a.hitsfx=4
	a.hittime=6
	a.hitcolour=7
	--a.gun=actor.make(e.actors.gun,e.actors.guns.machinegun,a.x,a.y,0,0,a.cinit,Enums.colours.dark_purple)
	actor.make(ea.gun,ea.guns.machinegun,a.x-10,a.y,0,0,a.cinit,e.colours.dark_purple)
	a.coin=0
	animation.make(a,10,2)
	a.flags=flags.set(a.flags,e.flags.player,e.flags.persistent)
end

local function control(a)
	Game.speed=math.clamp(a.vel,0.1,1)
	cursor.update(a.cursor)
	if SFX.positonal then
		love.audio.setPosition(a.x,a.y,0)
	end
end

local function draw(a)
	cursor.draw(a.cursor)
end

local function damage(a)
	Screen.pixeltrans=true
	Screen.pixelscale=0.1
	Camera.shake=20
end

local function dead(a)
	Game.speed=math.randomfraction(0.2)+0.25
	--Game.speed=1
	scores.save()
end

return
{
	make = make,
	control = control,
	draw = draw,
	damage = damage,
	dead = dead,
}