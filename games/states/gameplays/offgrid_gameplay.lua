local function make(g)
	g.level=3
	level.make(g,g.level)
end

local function control(g)

end

local function keypressed(g,key)
	if key=='escape' then
		game.state.make(g,Enums.games.states.title)
	elseif key=='z' then
		--g.level=math.clamp(g.level-1,1,#g.levels,true)
		level.make(g,g.level-1)
	elseif key=='x' then
		--g.level=math.clamp(g.level+1,1,#g.levels,true)
		level.make(g,g.level+1)
	end
--[[
	elseif key=='z' then
		--g.images.index=g.images.index-1
		g.textimages.index=g.textimages.index-1
	elseif key=='x' then
		--g.images.index=g.images.index+1
		g.textimages.index=g.textimages.index+1
	end
	g.textimages.index=math.clamp(g.textimages.index,1,#g.textimages,true)
--]]
end

local function gamepadpressed(g,button)
	if button=="a" then
		g.switch = not g.switch
	end
end

local function draw(g)
	local images=g.images[g.level]
	local animspeed=10
	if g.levels.current.animspeed then
		animspeed=g.levels.current.animspeed
	end
	local anim=math.floor((g.timer/animspeed)%#images)
	LG.draw(images[1+anim],0,0)
	if g.menu then
		menu.draw(g.menu)
	end
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}