local function make(a,c,size,spr)
	a.c=c or Enums.colours.pure_white
	a.size=size or 1
	a.spr=spr or 1
	a.scalex=1
end

local function control(a)
	local ea=Enums.actors
	a.scalex=math.sin(Timer)
	if Timer-a.delta>=30 then
		sfx.play(8)
		for i=1,20 do
			actor.make(ea.effect,ea.effects.spark,a.x,a.y)
		end
		a.delete=true
	end
end

return
{
	make = make,
	control = control,
}