local function make(a,c,size,char,hp)
	local e=Enums

	if #Joysticks>0 then
		module.make(a,EM.controller,EMC.move,EMC.moves.roguelike_gamepad_move)
		module.make(a,EM.controller,EMC.aim,EMC.aims.gamepad_actor_aim)
	else
		a.cursor=cursor.make(0,0)
		module.make(a,EM.controller,EMC.move,EMC.moves.topdown_keyboard_move)
		module.make(a,EM.controller,EMC.aim,EMC.aims.mouse_actor_aim)
	end

	a.cinit=c or EC.dark_blue
	a.c=a.cinit or EC.blue
	a.size=size or 1
	a.char=char or "X"
	a.hp=hp or 8

	a.flags=flags.set(a.flags,EF.character,EF.persistent,EF.damageable, EF.shootable, EF.explosive)

end

local function control(a)
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
	Game.camera.shake=20
end

local function dead(a)
	Game.speed=math.randomfraction(0.2)+0.25
end

return
{
	make = make,
	control = control,
	draw = draw,
	damage = damage,
	dead = dead,
}