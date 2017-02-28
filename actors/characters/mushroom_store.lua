local function make(a,c,size,spr,hp,ct)
	local e=Enums
	local ec=Enums.controllers
	a.cinit=c or e.colours.yellow
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 97
	a.hp=hp or 16
	controller.make(a,ec.target_seek)
	a.hit=0
	a.hitsfx=3
	a.hittime=6
	a.hitcolour=7
	a.target={}
	a.target.x=Game.width/2
	a.target.y=Game.height/3
	a.speed=2

	animation.make(a,10,2)
	a.flags=flags.set(a.flags,e.flags.enemy)
end

local function control(a)

end

local function draw(a)
	local dist=vector.distance(a.x,a.y,Player.x,Player.y)
	if dist<30 then
		--Enums.colours.white,Enums.colours.yellow
		local c=Enums.colours
		local g=love.graphics
		local s=Game.settings.scores

	--TODO make this into menu library
		local xoff,yoff,h=-25,-65,50
		g.setColor(Palette[c.dark_purple])
		g.rectangle("fill",a.x+xoff+1,a.y+yoff+1,52,h+2)
		g.setColor(Palette[c.black])
		g.rectangle("fill",a.x+xoff,a.y+yoff,50,h)
		g.setColor(Palette[c.indigo])
		g.rectangle("line",a.x+xoff,a.y+yoff,51,h+1)
		g.print("u will buy",a.x+xoff/2,a.y+yoff/2)
	end
end

local function dead(a)
	local ea=Enums.actors
	local port=actor.make(ea.effect,ea.effects.portal,math.floor(a.x),math.floor(a.y))
	port.level=Levels.store
end

return
{
	make = make,
	control = control,
	draw = draw,
	dead = dead,
}