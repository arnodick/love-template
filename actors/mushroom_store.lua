local function make(a,c,size,spr,hp)
	a.cinit=c or EC.yellow
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 97
	a.hp=hp or 1
	controller.make(a,ECT.move,ECT.moves.ai_target_seek,Game.width/2,Game.height/2)
	a.hit=0
	a.hitsfx=3
	a.hittime=6
	a.hitcolour=7
	a.speed=2

	module.make(a,EM.animation,10,2)
	module.make(a,EM.hitradius,4)
	a.flags=flags.set(a.flags,EF.character,EF.enemy,EF.damageable, EF.shootable, EF.explosive)
end

local function control(a)
	local dist=vector.distance(a.x,a.y,Player.x,Player.y)

	if dist<30 then
		if not a.menu then
			module.make(a,EM.menu,EMM.text,a.x,a.y-38,50,50,{"what you buy do you want to buy the powerup ?"},EC.orange,EC.dark_green)
			local m=a.menu
			module.make(m,EM.border,EC.indigo,EC.dark_purple)
			m.font=LG.newFont("fonts/pico8.ttf",8)--TODO put font in menu makey
		end
	elseif a.menu then
		a.menu=nil
	end
end

local function draw(a)

end

local function dead(a)

end

return
{
	make = make,
	control = control,
	draw = draw,
	dead = dead,
}