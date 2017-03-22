local function make(a,c,size,spr,hp,ct)
	local e=Enums

	if #Joysticks>0 then
		controller.make(a,e.controllers.gamepad)
	else
		a.cursor=cursor.make(0,0)
		controller.make(a,e.controllers.keyboard,e.controllers.mouse)
	end

	a.cinit=c or EC.dark_blue
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 81
	a.hp=hp or 8
	a.hit=0
	a.hitsfx=4
	a.hittime=6
	a.hitcolour=7
	tail.make(a,a.cinit,9)
	a.inv={}
	a.inv.i=1
	a.inv.max=2
	actor.make(EA.item,EA.items.machinegun,a.x,a.y,0,0,EC.dark_purple,EC.dark_purple)
	--actor.make(EA.item,EA.items.hammer,a.x,a.y,0,0,EC.dark_purple,a.cinit)
	a.coin=0
	animation.make(a,10,2)
	a.flags=flags.set(a.flags,e.flags.persistent)
end

local function control(a)
	if Game.pause then
		Game.speed=0
	else
		if Game.levels.current.t==Enums.levels.store then--TODO make this a level value (level.time = time slow or not)
			Game.speed=1
		else
			Game.speed=math.clamp(a.vel,0.1,1)
		end
	end
	if a.controller.powerup then
		if #a.inv>1 then
			local temp=a.inv[1]
			table.remove(a.inv,1)
			table.insert(a.inv,temp)
		end
	end
	cursor.update(a.cursor)
	--if a.controller.powerup then	
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