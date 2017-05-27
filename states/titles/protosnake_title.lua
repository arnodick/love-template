local function make(g)
	g.state.font=LG.newFont("fonts/Kongtext Regular.ttf",64)
	g.scores=scores.load()
	music.play(1)
	module.make(g.state,EM.menu,EMM.interactive,Game.width/2,180,60,30,{"START","OPTIONS"},EC.orange,EC.dark_green,"left",{game.state.make,game.state.make},{{Game,Enums.states.gameplay},{Game,Enums.states.option}})
	--EC.indigo,EC.dark_purple

end

local function control(g)

end

local function keypressed(g,key)

end

local function gamepadpressed(g,button)

end

local function draw(g)

end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}