local function make(a,c,size,spr,hp,ct)
	local e=Enums
	a.cinit=c or e.colours.dark_green
	a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 97
	a.hp=hp or 8
	controller.make(a,ct or e.controllers.enemy)
	a.hit=0
	a.hitsfx=3
	a.hittime=6
	a.hitcolour=7
	gun.make(a,2,9,-math.pi,0,Enums.colours.green)
	animation.make(a,10,2)
end

local function control(a)
	
end

local function hitground(a)

end

local function draw(a)
	--love.graphics.points(a.x,a.y)
end

return
{
	make = make,
	control = control,
	hitground = hitground,
	draw = draw,
}