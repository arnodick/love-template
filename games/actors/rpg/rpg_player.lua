local function make(g,a,c,size,char,hp)
	local e=Enums

	if #Joysticks>0 then
		module.make(a,EM.controller,EMC.move,EMCI.gamepad)
		module.make(a,EM.controller,EMC.action,EMCI.gamepad)
		--module.make(a,EM.controller,EMC.move,EMC.moves.roguelike_gamepad_move)
		--module.make(a,EM.controller,EMC.action,EMC.actions.roguelike_gamepad_action)
	else
		module.make(a,EM.controller,EMC.move,EMC.moves.roguelike_keyboard_move)
	end

	a.cinit=c or EC.dark_blue
	a.c=a.cinit or EC.blue
	a.size=size or 1
	a.char=char or "X"
	a.hp=hp or 8

	a.flags=flags.set(a.flags,EF.character,EF.persistent,EF.damageable, EF.shootable, EF.explosive)

end

local function control(g,a)
	if SFX.positonal then
		love.audio.setPosition(a.x,a.y,0)
	end

	if a.controller.action.use then
		a.c=EC.red
	else
		a.c=a.cinit
	end
end

local function draw(g,a)
	cursor.draw(a.cursor)
end

local function damage(a)
	local g=Game
	g.screen.pixeltrans=true
	g.screen.pixelscale=0.1
	g.screen.shake=20
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