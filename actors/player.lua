local function make(a,c,size,spr,hp,ct)
	local e=Enums

	if #Joysticks>0 then
		controller.make(a,ECT.move,ECT.moves.gamepad_actor_move)
		controller.make(a,ECT.aim,ECT.aims.gamepad_actor_aim)
	else
		a.cursor=cursor.make(0,0)
		controller.make(a,ECT.move,ECT.moves.keyboard_actor_move)
		controller.make(a,ECT.aim,ECT.aims.mouse_actor_aim)
	end

	a.cinit=c or EC.dark_blue
	a.c=a.cinit or EC.blue
	a.size=size or 1
	a.spr=spr or 81
	a.hp=hp or 8
	a.hit=0
	a.hitsfx=4
	a.hittime=6
	a.hitcolour=7
	module.make(a,EM.tail,a.cinit,9)
	module.make(a,EM.inv,2)
	actor.make(EA.machinegun,a.x,a.y,0,0,EC.dark_purple,EC.dark_purple)
	a.coin=0
	module.make(a,EM.animation,10,2)
	--animation.make(a,2,32) --SWEET GLITCH ANIMATION
	module.make(a,EM.hitradius,4)
	a.flags=flags.set(a.flags,EA.flags.character,EF.persistent,EF.damageable, EF.shootable, EF.explosive)
end

local function control(a)
	--a.cinit=math.floor((Game.timer/2)%16)+1 --SWEET COLOUR CYCLE
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
		elseif Game.levels.current.t==Enums.levels.store then--TODO make this a level value (level.time = time slow or not)
			Game.speed=1
		else
			Game.speed=math.clamp(a.vel,0.1,1)
		end
	end
	if a.controllers.aim.powerup then
		if #a.inv>1 then
			local temp=a.inv[1]
			table.remove(a.inv,1)
			table.insert(a.inv,temp)
		end
	end
	cursor.update(a.cursor)
	--if a.controllers.powerup then	
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