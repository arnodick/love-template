local function make(i)

end

local function control()

end

local function keypressed(i,key)
	if key=="space" then
		Game.settings=game.changestate(Enums.states.title)
	end
end

local function draw(i)
	love.graphics.print("INTRO",Game.width/2,Game.height/2)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	draw = draw,
}