local function make(g,a,c,size,spr,hp)
	a.cinit=c or EC.yellow
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 97
	a.hp=hp or 1

	a.speed=2

	module.make(a,EM.controller,EMC.move,EMCI.ai,g.level.map.width/2,g.level.map.height/4*3)
	module.make(a,EM.sound,3,"damage")
	module.make(a,EM.animation,EM.animations.frames,10,2)
	module.make(a,EM.hitradius,4)
	a.flags=flags.set(a.flags,EF.character,EF.enemy,EF.damageable, EF.shootable, EF.explosive)
end

local function control(g,a)
	local dist=vector.distance(a.x,a.y,g.player.x,g.player.y)

	if dist<30 then
		if not a.menu then
			local zoomchange=2.5-g.camera.zoom
			module.make(g.camera,EM.transition,easing.inOutSine,"zoom",g.camera.zoom,zoomchange,180)
			module.make(a,EM.menu,EMM.text,a.x,a.y-38,50,50,{"what you buy do you want to buy the powerup ?"},EC.orange,EC.dark_green)
			local m=a.menu
			module.make(m,EM.border,EC.indigo,EC.dark_purple)
			m.font=LG.newFont("fonts/pico8.ttf",8)--TODO put font in menu makey
		end
	elseif a.menu then
		local zoomchange=-(g.camera.zoom-1)
		module.make(g.camera,EM.transition,easing.inOutSine,"zoom",g.camera.zoom,zoomchange,20)
		a.menu=nil
	end

	if a.controller then
		local movedist=vector.distance(a.x,a.y,a.controller.move.target.x,a.controller.move.target.y)
		if movedist<=a.speed then
			a.vel=0
			a.controller=nil
		end
	end
end

local function dead(a)
	local zoomchange=-(Game.camera.zoom-1)
	module.make(Game.camera,EM.transition,easing.inOutSine,"zoom",Game.camera.zoom,zoomchange,10)
end

return
{
	make = make,
	control = control,
	dead =  dead,
}