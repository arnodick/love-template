local function make(i)
	i.canvas=LG.newCanvas(640,480)
	local top_left  = {200, 0,   0,     0, 255, 255, 255, 255} 
	local top_right = {400, 0,   1,     0, 255, 255, 255, 255}
	local bot_right = {640, 480, 1,     1, 255, 255, 255, 255}
	local bot_left  = {0,   480, 0,     1, 255, 255, 255, 255}
	local vertexes = {top_left,top_right,bot_right,bot_left}
	i.mesh = love.graphics.newMesh(vertexes, "fan", "dynamic")
end

local function control()

end

local function keypressed(i,key)
	if key=="space" then
		game.changestate(Game,Enums.states.title)
	end
end

local function gamepadpressed(i,button)
	if button=="start" then
		game.changestate(Game,Enums.states.title)
	end
end

local function draw(i)
	LG.setCanvas(i.canvas)
		LG.clear()
		--LG.setColor(Palette[EC.blue])
		--LG.rectangle("fill",0,0,640,480)
		LG.print("INTRO\nBLAHBLAHBLAH",Game.width/2,400-Game.timer)

	LG.setCanvas()
	--love.graphics.draw(i.canvas,Screen.xoff,Screen.yoff,0,Screen.scale,Screen.scale,0,0,-0.5,0)
	i.mesh:setTexture(i.canvas)
	love.graphics.draw(i.mesh,0,0)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}