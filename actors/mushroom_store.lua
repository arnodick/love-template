local function make(a,c,size,spr,hp,ct)
	local e=Enums
	local ec=Enums.controllers
	a.cinit=c or EC.yellow
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 97
	a.hp=hp or 1
	controller.make(a,ECT.move,ECT.moves.target_seek,Game.width/2,Game.height/2)
	a.hit=0
	a.hitsfx=3
	a.hittime=6
	a.hitcolour=7
	a.speed=2

	animation.make(a,10,2)
	a.flags=flags.set(a.flags,EA.flags.character,e.flags.enemy)
end

local function control(a)
	local dist=vector.distance(a.x,a.y,Player.x,Player.y)

	if dist<30 then
		if not a.menu then
			a.menu=menu.make(EM.text,a.x,a.y-38,50,50,{"what you buy do you want to buy the powerup ?"},EC.orange,EC.dark_green)
			local m=a.menu
			border.make(m,m.x,m.y,m.w,m.h,EC.indigo,EC.dark_purple)
			m.font=LG.newFont("fonts/pico8.ttf",8)--TODO put font in menu makey
		end
	elseif a.menu then
		a.menu=nil
	end
end

local function draw(a)
	if a.menu then
		menu.draw(a.menu)
	end
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