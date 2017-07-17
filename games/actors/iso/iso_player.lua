local function make(a,c,size,spr,hp)
	local e=Enums

	if #Joysticks>0 then
		module.make(a,EM.controller,EMC.move,EMCI.gamepad)
		module.make(a,EM.controller,EMC.aim,EMCI.gamepad)
		module.make(a,EM.controller,EMC.action,EMCI.gamepad)
	end

	a.cinit=c or EC.dark_blue
	a.c=a.cinit or EC.blue
	a.size=size or 2
	a.spr=spr or 48
	a.hp=hp or 8

	module.make(a,EM.animation,EM.animations.frames,10,2)
	module.make(a,EM.hitradius,4)
	a.flags=flags.set(a.flags,EF.character,EF.persistent,EF.damageable, EF.shootable, EF.explosive)
end

local function control(a)
	if SFX.positonal then
		love.audio.setPosition(a.x,a.y,0)
	end
end

local function draw(a)
	
end

local function damage(a)
	Screen.pixeltrans=true
	Screen.pixelscale=0.1
	Game.camera.shake=20
end

local function dead(a)

end

return
{
	make = make,
	control = control,
	draw = draw,
	damage = damage,
	dead = dead,
}