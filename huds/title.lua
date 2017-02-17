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
	love.graphics.print("TITLE",Game.width/2,Game.height/2)
	scores.draw(Game.width/2,Game.height/2,Enums.colours.white,Enums.colours.yellow)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	draw = draw,
}