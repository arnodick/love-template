local function make(g)
	g.state.imgdata=love.image.newImageData(g.canvas.buffer:getWidth()-1,g.canvas.buffer:getHeight()-1)
	g.state.font=LG.newFont("fonts/Kongtext Regular.ttf",20)
	music.play(2)
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