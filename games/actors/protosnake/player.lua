local function make(a,c,size,spr,hp)
	local e=Enums

	if #Joysticks>0 then
		--module.make(a,EM.controller,EMC.move,EMC.moves.topdown_gamepad_move)
		--module.make(a,EM.controller,EMC.aim,EMC.aims.gamepad_actor_aim)
		--module.make(a,EM.controller,EMC.action,EMC.actions.topdown_gamepad_action)
		module.make(a,EM.input,EMI.move,EMI.moves.gamepad_move)
		module.make(a,EM.input,EMI.aim,EMI.aims.gamepad_aim)
		module.make(a,EM.input,EMI.action,EMI.actions.gamepad_action)

		module.make(a,EM.controller,EMC.topdown_move)
		module.make(a,EM.controller,EMC.topdown_aim)
		module.make(a,EM.controller,EMC.topdown_action)
	else
		--a.cursor=cursor.make(0,0)
		--module.make(a,EM.controller,EMC.move,EMC.moves.topdown_keyboard_move)
		--module.make(a,EM.controller,EMC.aim,EMC.aims.mouse_actor_aim)
	end

	a.cinit=c or EC.dark_blue
	a.c=a.cinit or EC.blue
	a.size=size or 1
	a.spr=spr or 81
	a.hp=hp or 8

	a.coin=0

	module.make(a,EM.hit,4,6,EC.white)
	module.make(a,EM.animation,EM.animations.frames,10,2)
	module.make(a,EM.hitradius,4)
	module.make(a,EM.tail,a.cinit,9)
	module.make(a,EM.inventory,2)
	actor.make(EA[Enums.games[Game.t]].machinegun,a.x,a.y,0,0,EC.dark_purple,EC.dark_purple)
	a.flags=flags.set(a.flags,EF.character,EF.persistent,EF.damageable, EF.shootable, EF.explosive)
	print(EF.shootable)

	--animation.make(a,2,32) --SWEET GLITCH ANIMATION
end

local function control(a)
	--a.cinit=math.floor((Game.timer/2)%16)+1 --SWEET COLOUR CYCLE
	local gamename=Enums.games[Game.t]
	if Game.pause then
		Game.speed=0
	else
		if Game.ease then
			if Game.speed<a.vel then
				Game.speed=Game.speed+0.01
			else
				Game.speed=a.vel
				Game.ease=false
			end
		elseif Game.levels.current.t==Enums.games.levels[gamename].store then--TODO make this a level value (level.time = time slow or not)
			Game.speed=1
		else
			Game.speed=math.clamp(a.vel,0.1,1)
		end
	end
	--[[
	if a.controller.aim.action then
		if #a.inventory>1 then
			local temp=a.inventory[1]
			table.remove(a.inventory,1)
			table.insert(a.inventory,temp)
		end
	end
	--]]
	cursor.update(a.cursor)
	--if a.controller.action then	
	--end
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