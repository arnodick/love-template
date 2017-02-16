local function make(a,c,size,spr,hp,ct)
	local e=Enums
	local ec=Enums.controllers
	a.cinit=c or e.colours.dark_green
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 49
	a.hp=hp or 8
	controller.make(a,ec.collide_reverse,ec.shoot_accurate)
	a.hit=0
	a.hitsfx=3
	a.hittime=6
	a.hitcolour=7
	a.target=Player
	gun.make(a,1,9,-math.pi,0,Enums.colours.green)
	animation.make(a,10,2)
end

local function control(a)
	
end

local function hitground(a)

end

local function draw(a)

end

return
{
	make = make,
	control = control,
	hitground = hitground,
	draw = draw,
}