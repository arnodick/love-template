local function make(t)

end


local function control(t)

end

local function keypressed(t,key)
	if key=="space" then
		Game.settings=game.changestate(Enums.states.play)
	end
end

local function draw(t)
	local g=love.graphics
	local scores=Game.settings.scores
	g.print("TITLE",Game.width/2,Game.height/2)
	for i=1,#scores.high do
		g.print(scores.high[i],Game.width/2,Game.height/2+10*i)
	end
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	draw = draw,
}