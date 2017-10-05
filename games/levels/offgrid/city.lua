local function make(g,l)

end

local function control(g,l)

end

local function draw(g,l)
	local images=g.images[g.level]
	local animspeed=30
	if g.levels.current.animspeed then
		animspeed=g.levels.current.animspeed
	end
	local anim=math.floor((g.timer/animspeed)%#images)
	LG.draw(images[1+anim],0,0)
end

return
{
	make = make,
	control = control,
	draw = draw,
}