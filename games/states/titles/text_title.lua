local function make(g)
	g.char="x"
	g.switch=false
end

local function control(g)

end

local function keypressed(g,key)
	if key=="space" or key=="return" then
		--game.state.make(g,Enums.games.states.gameplay,Enums.games.modes.roguelike)
	elseif key=='escape' then
		game.state.make(g,Enums.games.states.intro)
	end
end

local function gamepadpressed(g,button)
	if button=="b" then
		game.state.make(g,Enums.games.states.intro)
	elseif button=="a" then
		g.switch = not g.switch
--[[
		local ps=Screen.pixelscale
		local pixelscaletarget=0.125
		local duration=120
		if ps>=1 then
			module.make(Screen,EM.transition,easing.linear,"pixelscale",ps,-(ps-pixelscaletarget),duration)
		else
			module.make(Screen,EM.transition,easing.linear,"pixelscale",ps,(1-ps),duration)
		end
--]]
	end
end

local function draw(g)
	local cellw=g.width/g.tile.width
	local cellh=g.height/g.tile.height
	local offset=5
	--LG.print("text title", g.width/2, g.height/2)
	for y=0,cellw do
		for x=0,cellh do
			LG.setColor(g.palette[((x+y-offset)%16)+1])
			LG.print(g.char,x*g.tile.width,y*g.tile.height)
		end
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